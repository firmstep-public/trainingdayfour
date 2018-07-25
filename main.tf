variable "ami_id" {
  description = "The AMI id to use for the Auto Scaling Group"
}

output "ami_id" {
  description = "This is the AMI provided"
  value = "${var.ami_id}"
}
