.PHONY: all prepare venv lint test clean

SHELL=/bin/bash

VENV_NAME?=venv
VENV_BIN=$(shell pwd)/${VENV_NAME}/bin
VENV_ACTIVATE=. ${VENV_BIN}/activate

PYTHON=${VENV_BIN}/python3

TEST?=bar

all:
	@echo "make deploy"
	@echo "    Run deployment scripts."
	@echo "make prepare"
	@echo "    Create python virtual environment and install dependencies."
	@echo "make lint"
	@echo "    Run lint and formatting on project."
	@echo "make test"
	@echo "    Run tests on project."
	@echo "make clean"
	@echo "    Remove python artifacts and virtualenv."

prepare:
	which virtualenv || python3 -m pip install virtualenv
	make venv

venv:
	test -d $(VENV_NAME) || virtualenv -p python3 $(VENV_NAME)
	${PYTHON} -m pip install -r requirements.txt

deploy: prepare
	${VENV_BIN}/ansible-playbook -i ansible/hosts \
      ansible/provisioning.yml $(ARGS)

dev: venv
	${PYTHON} -m pip install -r dev-requirements.txt
	${PYTHON} -m pip install -e src/.

lint: venv
	${VENV_BIN}/flake8 src
	${VENV_BIN}/black .

test: venv
	${PYTHON} -m pytest -vv tests

clean:
	find . -name '*.pyc' -exec rm -f {} +
	rm -rf $(VENV_NAME) *.eggs *.egg-info dist build docs/_build .cache
