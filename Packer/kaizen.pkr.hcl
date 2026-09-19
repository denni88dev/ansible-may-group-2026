packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" { # -> what kind of source is used to create an instance
  ami_name      = "my-image-{{ timestamp }}" #->make ami with diff names
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami    = "ami-0fef201115eefe936"
  ssh_username  = "ec2-user"
  ssh_keypair_name = "my-laptop-key"
  ssh_private_key_file = "~/.ssh/id_rsa" #-> ssh ec2-user@ip -i priv key loc - specify where private key leaves
  
  ami_regions = [   #-> deploy to other regions
    "us-east-2",
    "us-west-1",
    "us-west-2"
  ]
  ami_users = [ ]  #-> deploy to other aws accounts

}
build {        # build ami from abow instance
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" { #-> shell provisioner
    script = "script.sh"  # or inline = [    ]
  }
}
