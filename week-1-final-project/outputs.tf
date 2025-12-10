output "vpc_id" {
    description = "ID of the VPC"
    value = aws_vpc.main.id
}

output "instance_public_ip" {
    description = "Public IP of EC2 instance"
    value = aws_instance.web.public_ip
}

output "instance_url" {
    description  = "URL to access the web server"
    value = "http://${aws_instance.web.public_ip}"
}