resource "aws_elastic_beanstalk_application" "beanstalk_application" {
  name        = var.name
  description = var.description
}

resource "aws_elastic_beanstalk_environment" "beanstalk_environment" {
  name                = var.environment
  application         = aws_elastic_beanstalk_application.beanstalk_application.name
  solution_stack_name = "64bit Amazon Linux 2 v3.6.0 running Docker"


  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.max_size
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2_profile.name
  }
}

resource "aws_elastic_beanstalk_application_version" "default" {
  depends_on = [
    aws_elastic_beanstalk_application.beanstalk_application,
    aws_elastic_beanstalk_environment.beanstalk_environment,
    aws_s3_object.docker
  ]
  name        = var.environment
  application = var.name
  description = var.description
  bucket      = aws_s3_bucket.beanstalk_deploys.id
  key         = aws_s3_object.docker.id
}
