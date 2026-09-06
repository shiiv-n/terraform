resource "aws_security_group" "nginx-sg" {
    vpc_id = aws_vpc.my_vpc.id

    # inound rule to allow http traffic on port 80
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
    # outbound rule to allow all traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "nginx-sg"
    }
}