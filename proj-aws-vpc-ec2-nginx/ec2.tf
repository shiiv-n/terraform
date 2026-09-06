# create a ec2 instance in the public subnet
resource "aws_instance" "nginx_server" {
    ami = "ami-01a00762f46d584a1"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]
    associate_public_ip_address = true
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install nginx -y
                sudo systemctl enable nginx
                sudo systemctl start nginx
            EOF
    tags = {
        Name = "nginx_server"
    }
}
