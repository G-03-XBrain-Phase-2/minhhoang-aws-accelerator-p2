# W8 Capstone - Triển khai nginx trên AWS bằng Terraform

## Tóm tắt lab

Lab này dùng Terraform để tạo hạ tầng AWS tại region `ap-southeast-1`, gồm VPC public, EC2 Ubuntu, Application Load Balancer và security group. EC2 được bootstrap bằng `user_data.sh` để cài Docker, kubectl, minikube, sau đó chạy Deployment nginx trên Kubernetes và expose qua port `8080`. ALB nhận request HTTP port `80` và forward về EC2 port `8080`.

Bằng chứng trong thư mục `evidence/` cho thấy `terraform apply` đã tạo thành công 17 resources và URL của ALB truy cập được trang welcome của nginx.

## Mục tiêu

- Tạo VPC public có internet gateway và route table.
- Tạo 2 public subnet trong các availability zone của `ap-southeast-1`.
- Tạo EC2 Ubuntu để chạy Docker, minikube và nginx trên Kubernetes.
- Tạo ALB public để truy cập ứng dụng thông qua DNS name.
- Xuất URL của ALB bằng Terraform output.

## Nội dung thực hiện

- `modules/vpc`: tạo VPC CIDR `10.0.0.0/16`, 2 public subnet, internet gateway, public route table, ALB security group và EC2 security group.
- `modules/ec2`: lấy Ubuntu Noble 24.04 AMI mới nhất, tạo SSH key pair bằng provider `tls`, lưu private key vào `~/.ssh/capstone-key.pem`, tạo EC2 instance loại `c7i-flex.large`.
- `modules/ec2/user_data.sh`: cài Docker, kubectl, minikube; tạo Deployment nginx 3 replicas và Service NodePort; port-forward service ra `0.0.0.0:8080`.
- `modules/alb`: tạo Application Load Balancer, target group HTTP port `8080`, gắn EC2 vào target group và tạo listener HTTP port `80`.
- `outputs.tf`: xuất DNS name của ALB qua output `url`.

## Công nghệ sử dụng

- Terraform `>= 1.0`
- Provider `hashicorp/aws` `~> 4.0`
- Provider `hashicorp/tls` `~> 4.0`
- Provider `hashicorp/local` `~> 2.5`
- AWS EC2, VPC, Security Group, Application Load Balancer
- Docker, kubectl, minikube
- Kubernetes Deployment và Service
- nginx

## Cấu trúc file

```text
w8/capstone/
|-- main.tf
|-- variables.tf
|-- terraform.tfvars
|-- outputs.tf
|-- .terraform.lock.hcl
|-- modules/
|   |-- vpc/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   `-- outputs.tf
|   |-- ec2/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |   `-- user_data.sh
|   `-- alb/
|       |-- main.tf
|       |-- variables.tf
|       `-- outputs.tf
`-- evidence/
    |-- resource apply & url output.png
    `-- web through url.png
```

## Cách chạy

Yêu cầu trước khi chạy:

- Đã cài Terraform.
- AWS credentials đã cấu hình với profile `default`.
- Tài khoản AWS có quyền tạo VPC, EC2, key pair, ALB và security group.

Chạy Terraform trong thư mục lab:

```bash
cd w8/capstone
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Sau khi apply xong, lấy URL:

```bash
terraform output url
```

## Kiểm tra kết quả

Bằng chứng đã có:

- `evidence/resource apply & url output.png`: Terraform báo `Apply complete! Resources: 17 added, 0 changed, 0 destroyed.` và output URL `capstone-alb-1030300951.ap-southeast-1.elb.amazonaws.com`.
- `evidence/web through url.png`: trình duyệt truy cập ALB URL và hiển thị trang `Welcome to nginx!`.

Hình ảnh bằng chứng:

![Terraform apply thành công và output ALB URL](evidence/resource%20apply%20%26%20url%20output.png)

![Truy cập nginx thông qua ALB URL](evidence/web%20through%20url.png)

Có thể kiểm tra lại bằng cách mở URL từ output Terraform trên trình duyệt:

```text
http://<alb-dns-name>
```

## Dọn dẹp tài nguyên

Khi không cần lab nữa, chạy:

```bash
cd w8/capstone
terraform destroy
```

Terraform có tạo file private key local tại:

```text
~/.ssh/capstone-key.pem
```

Kiểm tra và xóa file này nếu không còn cần sử dụng sau khi hủy tài nguyên.

## Ghi chú

- `terraform.tfvars` đang mở ingress từ `0.0.0.0/0` cho SSH `22`, HTTP `80`, HTTPS `443` và port ứng dụng `8080`. Nếu dùng ngoài lab, nên giới hạn CIDR theo IP cần truy cập.
- EC2 được gắn tag mặc định `Project = "Capstone-w8"` và `Owner = "minhhoang"` trong các module.
- Cần kiểm tra thêm nếu thay đổi instance type, CIDR hoặc region để đảm bảo tài nguyên vẫn phù hợp với quota AWS.
