from diagrams import Diagram, Cluster
from diagrams.aws.network import VPC, PrivateSubnet, PublicSubnet, InternetGateway, NATGateway, ELB
from diagrams.aws.compute import EC2, AutoScaling
from diagrams.aws.database import RDS
from diagrams.aws.general import User

with Diagram("고가용성 웹 애플리케이션 아키텍처", show=False, filename="aws_ha_web_architecture"):
    # 외부 사용자 정의
    user = User("사용자")

    # AWS 클라우드 내 VPC 정의
    with Cluster("VPC"):
        # 네트워크 구성 요소
        igw = InternetGateway("IGW")
        nat = NATGateway("NAT GW")

        # 가용 영역(Availability Zones) 및 서브넷
        with Cluster("Public Subnet (AZ 1)"):
            public_subnet_a = PublicSubnet(" ")

        with Cluster("Public Subnet (AZ 2)"):
            public_subnet_b = PublicSubnet(" ")

        with Cluster("Private Subnet (AZ 1)"):
            private_subnet_a = PrivateSubnet(" ")
            asg_a = AutoScaling("ASG")
            ec2_a = EC2("Web/App")
            asg_a >> ec2_a # ASG가 EC2 인스턴스를 관리함을 표현

        with Cluster("Private Subnet (AZ 2)"):
            private_subnet_b = PrivateSubnet(" ")
            asg_b = AutoScaling("ASG")
            ec2_b = EC2("Web/App")
            asg_b >> ec2_b # ASG가 EC2 인스턴스를 관리함을 표현

        # 데이터베이스 클러스터
        with Cluster("Private Subnet (DB)"):
            db_master = RDS("DB Master")
            db_master - RDS("DB Read Replica")

        # 로드 밸런서
        alb = ELB("ALB")

        # 트래픽 흐름 정의
        user >> alb >> [ec2_a, ec2_b]
        [ec2_a, ec2_b] >> db_master
        public_subnet_a - igw
        public_subnet_b - igw
        private_subnet_a - nat
        private_subnet_b - nat
        nat - igw
