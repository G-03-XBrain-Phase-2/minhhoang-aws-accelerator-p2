# W8 Day 4 - Kubernetes Service NodePort

## Tóm tắt lab

Lab này tạo một Deployment tên `hello-nginx-deployment` và một Service kiểu `NodePort`
tên `hello-nginx-service` từ file `node-port.yaml`.

Deployment quản lý 3 Pod chạy Nginx với label `app: web`. Service sử dụng selector
`app: web` để chuyển tiếp request đến các Pod này.

## Mục tiêu

- Hiểu vai trò của Service trong Kubernetes.
- Tạo Service kiểu `NodePort` để truy cập ứng dụng từ bên ngoài cluster.
- Kiểm tra thông tin Service bằng `kubectl`.
- Lấy URL truy cập Service khi sử dụng Minikube.

## Service là gì?

Pod có thể được tạo lại và thay đổi địa chỉ IP trong quá trình chạy. Service cung cấp một
điểm truy cập ổn định để các client kết nối đến một nhóm Pod phù hợp với selector của
Service.

Trong lab này, Service `hello-nginx-service` chọn các Pod có label `app: web` và phân phối
request đến cổng `80` của các Pod đó.

Service có kiểu `NodePort`, vì vậy Kubernetes mở cổng `30007` trên Node để cho phép truy
cập ứng dụng từ bên ngoài cluster.

## Cấu hình cổng

| Thuộc tính | Giá trị | Ý nghĩa |
| --- | --- | --- |
| `port` | `80` | Cổng của Service bên trong cluster |
| `targetPort` | `80` | Cổng Nginx đang lắng nghe trong Pod |
| `nodePort` | `30007` | Cổng được mở trên Node để truy cập từ bên ngoài |

## Cấu trúc file

```text
nodeport/
├── node-port.yaml
└── README.md
```

## Cách chạy

Yêu cầu có Kubernetes cluster đang hoạt động và `kubectl` đã được cấu hình kết nối đến
cluster. Để sử dụng lệnh lấy URL trong lab, cluster cần chạy bằng Minikube.

Chạy lệnh sau trong thư mục `w8/day4/nodeport`:

```bash
kubectl apply -f node-port.yaml
```

## Kiểm tra kết quả

Kiểm tra danh sách Service:

```bash
kubectl get svc
```

Xem riêng Service `hello-nginx-service`:

```bash
kubectl get svc hello-nginx-service
```

Kết quả sẽ hiển thị Service có kiểu `NodePort` và ánh xạ cổng dạng `80:30007/TCP`.

Kiểm tra Deployment và các Pod được Service chọn:

```bash
kubectl get deployment,pod -l app=web
```

Lấy URL truy cập Service trên Minikube:

```bash
minikube service hello-nginx-service --url
```

Mở URL được trả về để kiểm tra trang mặc định của Nginx.

## Dọn dẹp tài nguyên

Xóa Deployment và Service sau khi hoàn thành lab:

```bash
kubectl delete -f node-port.yaml
```

## Ghi chú

- `svc` là tên viết tắt của resource `service` trong `kubectl`.
- Selector `app: web` của Service phải khớp với label của Pod để Service có thể chuyển
  tiếp request.
- Lệnh `kubectl get svc <name>` cần có khoảng trắng giữa `svc` và tên Service.
