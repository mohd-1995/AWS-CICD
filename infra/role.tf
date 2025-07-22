resource "aws_iam_role" "iam-role" {
  name = var.iam-role-name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance-prof" {
  name = "CICD-instance-profile"
  role = aws_iam_role.iam-role.name
}

resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

  depends_on = [aws_iam_role.iam-role]
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.iam-role.name
  policy_arn = var.iam-policy-arn

  depends_on = [aws_iam_role.iam-role]
}