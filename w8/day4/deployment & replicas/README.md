# W8 Day 4 - Kubernetes Deployment và Replicas

## Tóm tắt lab

Lab này tạo một Kubernetes Deployment tên `web` từ file `deployment.yaml`.
Deployment quản lý 3 Pod chạy container `hoangcute` với image `nginx:latest` và
khai báo cổng `80`.

Các Pod được gắn label `app: web`, khớp với selector của Deployment để Deployment
có thể quản lý chúng.

## Mục tiêu

- Làm quen với cấu trúc manifest Deployment.
- Hiểu mối quan hệ giữa Deployment, ReplicaSet và Pod.
- Kiểm tra trạng thái rollout của Deployment.
- Lọc các resource theo label.
- Thay đổi số lượng replica bằng `kubectl scale`.

## Cấu trúc file

```text
deployment & replicas/
├── deployment.yaml
└── README.md
```

## Cách chạy

Yêu cầu có Kubernetes cluster đang hoạt động và `kubectl` đã được cấu hình kết nối
đến cluster.

Chạy lệnh sau trong thư mục `w8/day4/deployment & replicas`:

```bash
kubectl apply -f deployment.yaml
```

Theo dõi trạng thái rollout của Deployment:

```bash
kubectl rollout status deployment/web
```

## Kiểm tra kết quả

Liệt kê Pod, ReplicaSet và Deployment có label `app=web`:

```bash
kubectl get po,rs,deploy -l app=web
```

Kết quả dự kiến có một Deployment tên `web`, một ReplicaSet do Deployment quản lý
và 3 Pod đang chạy.

## Thay đổi số lượng replica

Scale Deployment từ 3 lên 5 replica:

```bash
kubectl scale deployment/web --replicas=5
```

Kiểm tra lại các resource sau khi scale:

```bash
kubectl get po,rs,deploy -l app=web
```

Lệnh `kubectl scale` thay đổi số replica trên cluster nhưng không cập nhật giá trị
`replicas: 3` trong file `deployment.yaml`. Nếu áp dụng lại manifest, Deployment có
thể được đưa về 3 replica.

## Dọn dẹp tài nguyên

Xóa Deployment và các resource do Deployment quản lý:

```bash
kubectl delete -f deployment.yaml
```

## Ghi chú

- `po`, `rs` và `deploy` lần lượt là tên viết tắt của `pod`, `replicaset` và
  `deployment` trong `kubectl`.
- Cú pháp `deployment/web` xác định resource loại Deployment có tên `web`.
- Selector `app: web` trong Deployment phải khớp với label `app: web` trong Pod
  template.
