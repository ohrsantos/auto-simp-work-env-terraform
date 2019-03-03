#        1         2         3         4         5         6         7         8         9         0
#        48
#2345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
#######################################################################################################################
#SCRIPT_NAME="main.tf"
#######################################################################################################################
#OHRS_PROFILE_VERSION="0.01a"
#AUTHOR="Orlando Hehl Rebelo dos Santos"
#DATE_INI="03-03-2019"
#DATE_END="03-03-2019"
#######################################################################################################################
# For auto-simp security dev env

variable "region" {}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile                 = "motherfucker1"
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


# todo: review sg
resource "aws_security_group" "" {
    name = "allow_ssh"
    description = "Allow SSH connections"
        ingress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"] 
        }

        egress {
            from_port       = 0
            to_port         = 0
            protocol        = "-1"
            cidr_blocks     = ["0.0.0.0/0"]
        }
}

resource "aws_instance" "pub-jump-box-auto-simp" { 
    ami = "${lookup(var.am_images, var.region)}"
    instance_type = "t2.small"
    key_name      =  "${lookup(var.am_key_pairs, var.region)}"
    vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
    tags {
        Name = "pub-jump-box-auto-simp"
    }

    provisioner "remote-exec" {
        inline = [ 
            "hostname",
            "ip addr",
            "sudo ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime",
            "echo \"pub-jump-box-auto-simp\" > /etc/hostname",
            "echo \"127.0.0.1 pub-jump-box-auto-simp\" >> /etc/hosts",
            "cd ~",
            "git clone https://github.com/ohrsantos/ohrs-setup.git;cd ohrs-setup;./install.sh",
            "sudo bash -c echo 'ClientAliveInterval 120 >> /etc/ssh/sshd_config'",
            "sudo bash -c echo 'ClientAliveCountMax 720 >> /etc/ssh/sshd_config'"
       ]
    }   
        connection {
             type     = "ssh"
             user     = "ubuntu"
             private_key = "${file("/home/a1/.aws/ohrs-sa-east-1-kp.pem")}"
       }


} 
