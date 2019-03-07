#        1         2         3         4         5         6         7         8         9         0
#        48
#2345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
#######################################################################################################################
#SCRIPT_NAME="main.tf"
#######################################################################################################################
#OHRS_PROFILE_VERSION="0.03a"
#AUTHOR="Orlando Hehl Rebelo dos Santos"
#DATE_INI="03-03-2019"
#DATE_END="06-03-2019"
#######################################################################################################################
# For auto-simp security dev env

variable "region" {
    default = "sa-east-1"
}

variable "instance_type" {
    default ="t2.micro"
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  #profile                 = "motherfucker1"
}


variable "am_images" {
  type = "map"

  default = {
    "sa-east-1" = "ami-0318cb6e2f90d688b"
    "us-east-2" = "ami-0f65671a86f061fcd"
    "us-west-1" = "ami-0ad16744583f21877"
  }
}

variable "am_key_pairs" {
  type = "map"

  default = {
    "sa-east-1" = "ohrs-sa-east-1-kp"
    "us-east-1" = "ohrs-us-east-1-kp"
    "us-east-2" = "ohrs-us-east-2-kp"
    "us-west-1" = "ohrs-us-west-1-kp"
    "us-west-2" = "ohrs-us-west-2-kp"
  }
}
