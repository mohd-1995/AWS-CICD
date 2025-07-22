resource "aws_instance" "my-ec2" {
  ami = var.ami
  instance_type = var.instancetype
  key_name = var.keyname
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  iam_instance_profile = aws_iam_instance_profile.instance-prof.name

  root_block_device {
    volume_size = 30
  }

  user_data = templatefile("./tools.sh", {})

  tags = {
    Name = var.ec2
  }
}