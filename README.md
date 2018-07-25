# trainingdayfour
Training Day Four: Review how to use Terraform Variables, and look at how to lay out a Terraform Directory Structure.

# Reusability, Variables and Terraform Inputs
Variables within Terraform are the primary way for providing external information to your Template.

When a variable is created, it can have a type, a description, and a default value.

A variable looks like this:

```hcl
variable "ami_id" {
  description = "The AMI id to use for the Auto Scaling Group"
}
```

Because there was no `default` in the variable, when that Terraform template is run, it will require a value to be passed to terraform or else it will error.

Using our terminal we will test the ways we can pass variables to Terraform, we will all create a new directory called `vtest` and cd in to it.

Lets create a `main.tf` file in our directory, and create the variable above in it, as well as an output.
```bash
vim main.tf
```
We will press `i` to enter into interactive editing mode and type in the code below.
```hcl
variable "ami_id" {
  description = "The AMI id to use for the Auto Scaling Group"
}

output "ami_id" {
  description = "This is the AMI provided"
  value = "${var.ami_id}"
}
```

To save and exit the file in `vim` press the `esc` key to leave the interactive editing mode and type `:wq` to write the file to disk and quit.

We now have a basic terraform file that we can use to test the different ways we can pass variables to a template.

By default Terraform will prompt the CLI for any variable that doesn't have a default value.
Lets do that
Since it is a new terraform directory we need to initialise the terraform directory.
```bash
terraform init
```
Then we can apply.
```bash
terraform apply
```


The variable can be set via an environment variable:
```bash
$ TF_VAR_ami_id=ami-abc765 terraform apply
```

The variable can be set via a variable file which can be automatically loaded if it is called terraform.tfvars:
```
echo "ami_id=ami-537497" > terraform.tfvars
terraform apply
```
or manually loaded if it referenced as a command line switch
```
echo "ami_id=ami-537497" > somevars.tfvars
terraform apply -var-file=somefile.tfvars
```



# Organising Terraform resources

*  Namespace - Client, Company, department, or project
*  Global - VPC, Subnets, IAM, SNS, Dashboards, S3.
*  Environment (Such as dev, production, staging) - Resources that can be created and destroyed together
*  Stage - destroyable stages, such as Extract, Transform, Load, or Source, Test, Build, Deploy, Release, Notify
*  Management - Tooling that is global and largely immutible, Jenkins, bastion hosts.

### Folder Layout Example
- namespace
  - global
    - IAM         (v0.2.0)
    - VPC         (v0.2.0)
  - management
    - jenkins     (v0.1.0)
    - bastion     (v0.2.0)
  - environment
    - develop
      - frontend  (v0.2.0)
      - mysql     (v0.1.0)
      - tasks     (v0.4.0)
    - staging
      - frontend  (v0.2.0)
      - mysql     (v0.1.0)
      - tasks     (v0.3.0)
    - production       
      - frontend  (v0.1.0)
      - mysql     (v0.1.0)
      - tasks     (v0.2.0)

### Terraform GIT Versioned Module Layout
- namespace
    - IAM
      - v0.1.0
      - v0.2.0
    - VPC
      - v0.1.0
      - v0.2.0
    - jenkins
      - v0.1.0
    - bastion
      - v0.1.0
      - v0.2.0
    - frontend
      - v0.1.0
      - v0.2.0
    - mysql
      - v0.1.0
    - tasks
      - v0.1.0
      - v0.2.0
      - v0.3.0
      - v0.4.0


1.  By exclusively using modules in the used Terraform templates, you keep the code DRY.
2.  Keep the modules version tagged, so that changes to a module don't affect older templates and you can keep isolation between stages.
3.  Store all modules in their own repositry.
4.  Store the live infrastructure templates that use the modules in their own repositry.