# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/packer
packer {
  required_plugins {
    amazon = {
      version = ">= 1.3"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/source
source "amazon-ebs" "ubuntu" {
  ami_name      = "web-nginx-aws"
  instance_type = "t2.micro"
  region        = "us-west-2"

  source_ami_filter {
    filters = {
		  # COMPLETE ME complete the "name" argument below to use Ubuntu 24.04
      name = "ubuntu/images/hvm-ssd/ubuntu-focal-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] 
	}

  ssh_username = "ubuntu"
}

# https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build
build {
  name = "web-nginx"
  sources = [
    # COMPLETE ME Use the source defined above
    "source.amazon-ebs.ubuntu"
  ]
  
  # https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build/provisioner
  provisioner "shell" {
    inline = [
      "echo creating directories",
      # COMPLETE ME add inline scripts to create necessary directories and change directory ownership.
      
      # creating necessary directories
      "sudo mkdir -p /web/html",                        
      "sudo mkdir -p /etc/nginx/sites-available", 
      "sudo mkdir -p /etc/nginx/sites-enabled",

      # Setting correct ownership
      "sudo chown -R www-data:www-data /web/html",

      # Ensuring proper permissions
      "sudo chmod -R 755 /web/html"

    ]
  }

  provisioner "file" {
    # COMPLETE ME add the HTML file to your image

    source      = "files/index.html"
    destination = "/web/html/index.html"

  }

  provisioner "file" {
    # COMPLETE ME add the nginx.conf file to your image

    source      = "files/nginx.conf"
    destination = "/tmp/web/nginx.conf"
    
  }

  # COMPLETE ME add additional provisioners to run shell scripts and complete any other tasks
}

