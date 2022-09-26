##############
# Dependencies
FROM python:3.9 as base

WORKDIR /usr/src/app

# Install poetry for dep management
RUN pip install -U pip

RUN pip install -U pip  && \
    curl -sSL https://install.python-poetry.org  | python3 -

ENV PATH="/root/.local/bin:$PATH"

RUN poetry config virtualenvs.create false

# Install project manifest
COPY pyproject.toml poetry.lock ./

# Install production dependencies
RUN poetry install --no-root

RUN apt-get update && apt-get install -y git sshpass

#####################################
#              Test                 #
#####################################
FROM base AS test

COPY . .

# --no-root declares not to install the project package since we're wanting to take advantage of caching dependency installation
# and the project is copied in and installed after this step
RUN poetry install --no-interaction --no-ansi --no-root

# Simple tests
RUN echo 'Running Flake8' && \
    flake8 . && \
    echo 'Running Black' && \
    black --check --diff . && \
    echo 'Running Pylint' && \
    find . -name '*.py' | xargs pylint  && \
    echo 'Running Yamllint' && \
    yamllint . && \
    echo 'Running pydocstyle' && \
    pydocstyle . && \
    echo 'Running Bandit' && \
    bandit --recursive ./ --configfile .bandit.yml

ENTRYPOINT ["echo"]

CMD ["success"]

#############
# Ansible Collections
#
# This installs the Ansible Collections from collections/requirements.yml
# and the roles from roles/requirements.yml, as well as installing git.
FROM base AS ansible

WORKDIR /usr/src/app

# Uncomment if using galaxy installs
# COPY galaxy/requirements.yml galaxy-requirements.yml

ENV ANSIBLE_COLLECTIONS_PATH /usr/share/ansible/collections

COPY ./collections/requirements.yml ./collections/requirements.yml

# The conditional logic is here to cover the case where the user deletes the
# collection or role requirements file, in the event that they don't need it.
# The image includes 'fat' Ansible so most folk won't strictly need to
# add collections.
RUN if [ -e collections/requirements.yml ]; then \
    ansible-galaxy collection install -r collections/requirements.yml; \
    fi

#############
# Final image
#
# This creates a runnable CLI container
FROM python:3.9-slim AS cli

WORKDIR /usr/src/app

COPY --from=base /usr/src/app /usr/src/app
COPY --from=base /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=base /usr/local/bin /usr/local/bin
COPY --from=ansible /usr/share /usr/share

COPY . .

ENTRYPOINT ["ansible-playbook"]
