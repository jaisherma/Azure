# :rocket: DEP Launchpad for Azure <!-- omit in toc -->
[[_TOC_]]

## 1. Introduction

The **DEP Launchpad for Azure** enabler can be used by project teams to create the **Azure** infra resources necessary for their projects. Launch Pad behaves as environment wrapper to easily assemble the different iac components(as referred to as roles) as per the need of the project.

Project can choose to instantiate and maintain a launchpad as per their need. It is recommended to have one launchpad Per project env. 

<img src="images/dep-enabler-architecture.png">
The application(s) can then be deployed on top of this infra using their dedicated project pipelines.
<img src="images/launchpad-architecture.png">

## 2. IAC Components list


|# | IAC Component / Role * | Description       | General Availability |
|--|-------------------------|-------------------|-------------------|
|1 | [**Project Foundation**](https://innersource.soprasteria.com/dep/library/iac/iac-ansible-roles/projectfoundation/-/blob/production/README.md) | Bootstrap an Azure environment. Deploys the most common components ( Vnet, subnet, key vault, Recovery Service Vault, Backup policy, storage account etc.. ) that is required to onboard workload for a project. This is a mandatory component and a prerequiste for for all subsequent IAC components. <br/><br/>The following diagram illustrates the components created by this role.  <br/> <img src="images/projectfoundation/azure-foundation-components.png"> |Yes|
|2| [**Virtual Machines**](https://innersource.soprasteria.com/dep/library/iac/iac-ansible-roles/virtualmachine/-/blob/production/README.md) | Deploy one or more VMs as per the project needs. <br/><br/>The following diagram illustrates the components created by this role.  <br/> <img src="images/virtualmachines/azure-vm-components.png"> | Yes |
|3| [**Bastion Host**](https://innersource.soprasteria.com/dep/library/iac/iac-ansible-roles/bastionhost/-/blob/production/README.md) | This role deploys a **Azure Bastion Service**. <br/><br/>The following diagram illustrates the components created by this role.  <br/> <img src="images/azurebastion/azure-bastion-components.png"> | Yes |
|3| [**Gitlab Runner**](https://innersource.soprasteria.com/dep/library/iac/iac-ansible-roles/privaterunner/-/blob/production/README.md) | Deploy one or more **Private Gitlab runner**  <br/> <img src="images/privaterunner/azure-privaterunner-components.png"> | Yes |
|4| [**ProjectConfig Example**](https://innersource.soprasteria.com/dep/library/iac/iac-ansible-custom-roles/projectconfigexample/-/blob/production/README.md) | Project can refer to this custom configuration role to build project level configuration; that can be applied on the VMs created by VM role. This role provide few examples like configuring  on top of oracle, RHEL and Ubuntu Linux, Windows VMs.  | Yes |
|7| [**AKS**](https://innersource.soprasteria.com/dep/library/iac/iac-ansible-roles/aks/-/blob/production/README.md) | Deploy Azure Kubernates Service (PAAS) <br/> <img src="images/aks-components.png"> | Yes |
|5| **App Services** | Deploy an App Service | Expected in Q1 2023 |              
|6| **PostgreSQL** | Deploy Azure Database for PostgreSQL (PAAS) | Expected in Q1 2023 |

*For more details of each roles, click on the IAC component name.

## 3. Pre-requisites

Refer [here](Pre-requisites.md) for pre-requisites.


## 4. Initialize DEP Launchpad for your Project

### 4.1 Fork the Launchpad for Azure

The first step is to start by **forking** the [Project Launchpad for Azure](https://innersource.soprasteria.com/dep/library/iac/iac-launchpads/project-launchpad-for-azure) Gitlab repo.
<img src="images/fork-repo.png">

### 4.2 Generate Gitlab Tokens

Project should next **generate Gitlab token** via **user settings > Access Tokens**:

<img src="images/gitlab-pat-token.png">

**Note**: **Do not forget to save the Project Access Token once its created.**

### 4.3 Configure CICD Variables

Add the following variables to your **project CI/CD configuration (Settings > CI/CD > Variables)**:

<img src="images/configure-cicd-variables.png">

The details of the variables are as below :
| Variables          | Description       |
|-------------------------|-------------------|
| ARM_CLIENT_ID | The **client id** of your service principal. To get value refer [Pre-requisites section](Pre-requisites.md#how-to-create-service-principal)|
| ARM_CLIENT_SECRET | The **secret** of your service principal. To get value refer [Pre-requisites section](Pre-requisites.md#how-to-create-service-principal)|
| ARM_SUBSCRIPTION_ID | The **id** of your subscription |
| ARM_TENANT_ID | The **tenant id** of your subscription. To get value refer [Pre-requisites section](Pre-requisites.md#how-to-create-service-principal) |
| GITLAB_USER | The username to authenticate with the data source. <br />It is recommended to use the **Project Access Token name** instead of user name. This should be **Innersource Gitlab username** |
| GITLAB_TOKEN | The password to authenticate with the data source. You should use the **Project Access Token** for authentication. This should be **Innersource Gitlab token** |
| EMAIL_ID | An email address to Let’s Encrypt to automatically send you expiry notices when your certificate is coming up for renewal. |
| LOCATION| **Resource location** in Azure. As per the DSI recommendation it should be **"westeurope"** |
| PROJECT_PREFIX| Project prefix for the project. Should be of **5 character in length, and should start with a character**. <br /> <br />For example : proj1, stmic, ltapj etc... <br />The project prefix will be used in the naming of the resources created on azure. |
| PROJECT_ENV| The **Project environment** of the project. **Should be of 3 character in length, and should start with a character**. <br /><br /> For example :  poc, dev, stg, e01 etc... <br />The project prefix will be used in the naming of the resources created on azure. |

## 5. Configure Launchpad according to project need

### 5.1 Walkthrough of the Launchpad structure

<img src="images/launchpad-structure.png">

| Folder\File          | Description       |
|-------------------------|-------------------|
| template | This folder contains **requirements.yml.tmpl** and **requirements_versions.yml**. The **requirements.yml.tmpl** has the definition for all supported roles. The **requirements_versions.yml** maintains the list of launchpad versions with supporting role versions  |
| vars | Contains the **globals.yml**, through which projects can use of roles. <br/> Each role can have 3 actions <br/> - **deploy**   : Deploy the role(installs resources as per the role) <br/>  - **destroy**  : destroy / undo the role(uninstall the role ) <br/>  - **skip**   : skip the role  <br/> <br/> By default all roles are set to **Skip**. Project will have to explicitly set "deploy" action to use the role. <br/> <br/> Addtionally this folder will also contain a variable file for each role support by the launch pad. |
| Plays | Contains the launchpad-foundation.yml, launchpad-projectroles.yml & launchpad-roles.yml that have all the play instruction for deployment. |
| .gitlab-ci.yml | This file is where all the relevent CI/CD jobs are defined |
| VERSION | Hold the latest version for Lauchpad |


### 5.2 Prerequisites for IAC Roles
In order to use Azure IAC library following roles are mandatory and should be always present in requirements.yml.tmpl file
- **projectfoundation**

### 5.3 Steps to configure/setup a role for deployment

- The [**general pre-requistes**](#3-pre-requisites) and [**prerequisites for IAC Roles**](#52-prerequisites-for-iac-roles) should be configured
- Role definition should be defined in **requirements.yml.tmpl** file (refer to [IAC Components list](#2-iac-components-list) for all avialable roles)
- The role should be **enabled** in **globals.yml** file. Refer [here](#55-configurecustomize-iac-component) for more details.
- Role variable file located at **vars/<role name>.yml** should contain all the **customization** as per need ( for e.g. for virtual machine role, the specs for each VM should be defined). Refer [here](#55-configurecustomize-iac-component) for more details. 

### 5.4 Add/Enable IAC components to install

Project needs to ensure that all required role definitions are correctly identified and configured in requirements.yml.tmpl file. By default all roles will be defined in requirements.yml.tmpl.

The **projectfoundation** is mandatory roles for this launchpad. This role definition should not be modified/changed.

In case a new role needs to be added, project team can add the role definition to requirements.tmpl by referring to individual [roles](#2-iac-components-list).

For example, the below snapshot you will see virtual machine, bastion role & Custom Project roles defined in addition to the projectfoundation role.

<img src="images/requirements.png">

### 5.5 Configure/customize IAC component 

The **vars** directory will contain variable files.

The **globals.yml** file will hold all the defaults setting for the launchpad. The users can choose to deploy, destroy or skip a role as per their deployment need.

<img src="images/globals.png">

The variable file for a role will follow the naming convention < role name >.yml. For example, for virtualmachine it will be virtualmachine.yml. 
Each role Variable file will contain all necessary default configurations. If required, users may choose to override.

For illustration purpose please find below a sample configuration for virtualmachine.yml

<img src="images/virtual-machine.png">

Refer to [IAC Components](#2-iac-components-list) for specific details.

## 6. Launch CI/CD Pipeline to deploy

Any commit will trigger the CI/CD pipeline.
To manually launch the pipeline, navigate to  **Launchpad for Azure > CI/CD > Pipelines** - click on **Run pipeline**

<img src="images/pipeline.png">

After successful run of pipeline

<img src="images/pipeline-view.png">

This pipeline will run three stages i.e. Init, Validate , Deploy and Destroy (Manual in case of need)

**init/backend**:  Validates the Azure Credentials provided are valid and has good access to the target subscription configured. 

**validate/validate-launchpad & validate-folders**: validate-launchpad job install and validate all Ansible roles as defined in the requirements.tmpl. Validate folder job checks for Terraform & Roles directories and if doesn't exist then it will be created and also download scripts/ps1/PrepWindowsVMs.ps1 file from iac-launchpads-scripts/common/azure-scripts project.

**deploy-foundation/install-foundation**: Deploy the project foundation on target subscription. Also create and register foundation runner from launchpad.

**deploy-rolls/install-roles**: Deploy the enabled roles on target subscription using foundation runner.

**post-deploy/post-deploy-windows-config**: To enable Winrm through CustomScriptExtension on Windows VM.

**config-roles/Infra-config-roles**: Software configuration for enabled roles on target subscription using foundation runner.

**project-roles/project-config-roles**: Apply custom project configuration on top of the VMs deployed on target subscription using foundation runner.

**post-install/cleanup**: Un-register foundation runner from launchpad.

**unistall/uninstall-foundation-runner**: Remove foundation runner from launchpad.

**destroy/destroy-launchpad**: Manual trigger to destroy deploy resources. Please note resources created via project foundation will not be destroyed; Some component for each role willnot be destroyed. Manual intervention will be required for their cleanup. 

**post-error**: In the event of a pipeline failure, an alert will be generated to address the specific error encountered.

## 7. Project Infrastructure State

Project infrastructure is managed by **terraform**. Terraform stores the infrastructure state in a state file. 
As per launchpad design, the infra state for each role is stored in a dedicated state file.

The state files are stored in the Launchpad Gitlab infrastructure terraform registry.

The naming convention followed is **< project >-< env >-< role name >-tfstate**.

Project, env and role name would be in lower case.

For e.g : for a project:DEM22, env:POC
- The name of the project foundation state file will be **dem22-poc-projectfoundation-tfstate**
- The name of the virtual machine state file will be **dem22-poc-virtualmachine-tfstate**

<img src="images/Terraform-state.png">

## 8. Upgrade DEP Launchpad 
### 8.1. Upgrade DEP Launchpad from previous version(s)

The Project team can choose to upgrade their existing Launchpad to the latest version using Git Remote. 

You can follow these steps to upgrade the launchpad:

**Step1**: **Clone the latest [Project Launchpad for Azure](https://innersource.soprasteria.com/dep/library/iac/iac-launchpads/project-launchpad-for-azure) and checkout the latest version**
<br/>
<br/>
&emsp;&emsp;&emsp;&emsp;&emsp;*git clone https://< USERNAME >:< PAT >@innersource.soprasteria.com/dep/library/iac/iac-launchpads/project-launchpad-for-azure.git* <br/>
&emsp;&emsp;&emsp;&emsp;&emsp;*cd project-launchpad-for-azure* <br/>
&emsp;&emsp;&emsp;&emsp;&emsp;*git checkout master* <br/>
    
    
**Step2**: **Set up Git remote to point to the existing Project Launchpad Repo**
<br/>
<br/>
&emsp;&emsp;&emsp;&emsp;&emsp;*git remote add -t rel/< version > project-launchpad-for-azure_< version > https://< USERNAME >:< PAT >@innersource.soprasteria.com/< path-of-existing-repo >*<br/>
<br/>
&emsp;&emsp;&emsp;&emsp;&emsp;For e.g: <br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;*git remote add -t rel/v2.0.0 project-launchpad-for-azure_v2.0.0 https://USER:XXXX@innersource.soprasteria.com/myprojectgroup/infra/project-launchpad-for-azure.git* <br/><br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Here, in this example release version is taken as v2.0.0 <br/>
        
**Step3**: **Push the latest release to existing Project Launchpad Repo.** 
<br/>
<br/>
&emsp;&emsp;&emsp;&emsp;&emsp;*git push project-launchpad-for-azure_< version > +master:rel/< version > -f* <br/>
<br/>
&emsp;&emsp;&emsp;&emsp;&emsp;For e.g: <br/>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;*git push project-launchpad-for-azure_v2.0.0 +master:rel/v2.0.0 -f* <br/>
        
**Step4**: **Navigate to your existing repo https://innersource.soprasteria.com/< path-of-existing-repo >; You should now see a new branch rel/< version >.**

<img src="images/Launchpad_upgrade_branch.png">

**Step5**: **You can now merge the rel/< version > branch to the main branch (by default main branch is master).**

### 8.2. Permission required to upgrade DEP launchpad from version 3.x.x to 4.x.x version

If project is upgrading their launchpad from version 3.x.x to 4.x.x then two more permissions(Get Rotation policy & Set Rotation policy) needs to be added manually on disk keyvault of respective roles before upgrading to version 4.x.x as a pre-requisite. Below is illustration for AKS role & same steps can be performed for VM & private runner roles.

- On azure portal, select the respective role resource group.

  <img src="images/key-vault-add-permission-1.png">

- Select and edit disk keyvault to assign the required permissions(Get Rotation policy & Set Rotation policy) on application **dep-azu-iac-corp-app** and save the changes.

  <img src="images/key-vault-add-permission-2.png"> <br/><br/>
  
  <img src="images/key-vault-add-permission-3-1.png"> <br/><br/>
  
  <img src="images/key-vault-add-permission-4.png">


## 9. Digital Sobriety

Monitor your usage and spending is critically important for cloud infrastructures. It is important to manage and monitor your Azure consumption regularly. 

Ensure that all unused resources are deleted thus reducing the usage-based costs.

## 10. Limitations

### 10.1 Soft delete keyvault State

Removing the resources leads to the deletion of all resources except the key vaults and their associated keys, which are placed in a state of soft delete. This feature is activated as part of **New DSI Policy** for security reasons. Enabling soft deletion ensures that even if the key vault is deleted, both the key vault and its contents remain recoverable for the next 90 days.

This implies that after manual deletion or deletion via launchpad, you will not be able to re-create the resources with the same resource key or project prefix.

To resolve this issue either change the respective resource key e.g. vm01/pr01/aks01 in the respective role launchpad yml files under vars OR change the PROJECT_PREFIX/PROJECT_ENV CI/CD variables to a new unique value.

### 10.2 NIC & IP association

During the initial run of the launchpad, if the virtual machine is provisioned with a "Static" public IP (publiciptype : "Static"), and subsequently, in subsequent runs, it's determined that this public IP is no longer necessary (publiciptype  : "None"), the first step is to disassociate this IP from the network interface card (NIC) using the Azure Portal as shown below and then re-run the pipeline to apply the changed configuration.

<img src="images/dissociate-PIP.png">

Similarly, if there's a need to change the VM zone during subsequent runs, the same step should be followed, involving the disassociation of the IP from the network interface card (NIC) through the Azure Portal. <br/>
**Note:** Changing zone forces a new resource to be created. If this change is needed in existing VM then first take the backup of the VM so that the same can be restored later.

### 10.3 Resource Providers

By default, Terraform will attempt to register any Resource Providers that it supports, even if they're not used in your configurations to be able to display more helpful error messages. If you're running in an environment with restricted permissions, or wish to manage Resource Provider Registration outside of Terraform you may wish to disable this flag; however, please note that the error messages returned from Azure may be confusing as a result (example:
API version 2019-01-01 was not found for Microsoft.Foo).<br/><br/>
To solve this problem set new CICD variable **ARM_SKIP_PROVIDER_REGISTRATION** to **true** under setting > CI/CD.