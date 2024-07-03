#!/bin/bash

export projectfoundation_version="$(yq -r .\"${LAUNCHPAD_VERSION}\".projectfoundation ./template/requirements_versions.yml)"
export virtualmachine_version="$(yq -r .\"${LAUNCHPAD_VERSION}\".virtualmachine ./template/requirements_versions.yml)"
export bastionhost_version="$(yq -r .\"${LAUNCHPAD_VERSION}\".bastionhost ./template/requirements_versions.yml)"
export privaterunner_version="$(yq -r .\"${LAUNCHPAD_VERSION}\".privaterunner ./template/requirements_versions.yml)"
export projectconfigexample_version="$(yq -r .\"${LAUNCHPAD_VERSION}\".projectconfigexample ./template/requirements_versions.yml)"
export aks_version="$(yq -r .\"${LAUNCHPAD_VERSION}\".aks ./template/requirements_versions.yml)"
