# AWS에 Nginx를 배포하는 Terraform 코드

이 프로젝트는 Terraform을 사용하여 AWS(Amazon Web Services)에 간단한 Nginx 웹 서버를 배포하는 방법을 보여줍니다.

## 주요 기능

- AWS EC2 인스턴스를 생성합니다.
- 인스턴스에 Nginx를 자동으로 설치하고 실행합니다.
- 웹 트래픽(HTTP)과 SSH 접속을 허용하는 보안 그룹을 설정합니다.
- 배포된 서버의 퍼블릭 IP 주소를 출력합니다.

## 사전 요구 사항

이 코드를 실행하기 전에 다음 도구들이 설치 및 설정되어 있어야 합니다.

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (버전 1.0 이상)
- [AWS CLI](https://aws.amazon.com/cli/)
- AWS 자격 증명 (Access Key 및 Secret Key): `aws configure` 명령어를 통해 설정해야 합니다.

## 사용 방법

1.  이 코드가 있는 디렉터리에서 터미널을 엽니다.

2.  **Terraform 초기화**
    필요한 AWS 공급자 플러그인을 다운로드합니다.
    ```bash
    terraform init
    ```

3.  **배포 실행**
    인프라를 생성합니다. 중간에 실행 계획을 확인하고 `yes`를 입력하여 승인해야 합니다.
    ```bash
    terraform apply
    ```

4.  **서버 확인**
    `apply` 명령이 성공적으로 완료되면, `public_ip`라는 결과값이 터미널에 표시됩니다. 이 IP 주소를 웹 브라우저에서 열면 "Welcome to nginx!" 페이지를 볼 수 있습니다.

## 리소스 정리

배포한 모든 AWS 리소스를 삭제하여 더 이상 요금이 부과되지 않도록 하려면 다음 명령어를 실행하세요.

```bash
terraform destroy
```
마찬가지로, 삭제 계획을 확인하고 `yes`를 입력하여 승인해야 합니다.
