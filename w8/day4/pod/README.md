# W8 Day 4 - Kubernetes Pod

## Tóm tắt lab

Lab này tạo một Kubernetes Pod độc lập tên `hello-nginx` từ file `pod.yaml`.
Pod chạy một container tên `hoangcute` sử dụng image `nginx:latest` và khai báo cổng
`80`.

## Mục tiêu

- Làm quen với cấu trúc manifest Pod trong Kubernetes.
- Tạo và kiểm tra trạng thái Pod bằng `kubectl`.
- Xem log và thực thi lệnh bên trong container.
- Xóa Pod sau khi hoàn thành lab.

## Cấu trúc file

```text
pod/
├── pod.yaml
└── README.md
```

## Cách chạy

Yêu cầu có Kubernetes cluster đang hoạt động và `kubectl` đã được cấu hình kết nối
đến cluster.

Chạy các lệnh sau trong thư mục `w8/day4/pod`:

```bash
kubectl apply -f pod.yaml
```

Lệnh trên tạo hoặc cập nhật Pod theo nội dung manifest.

## Kiểm tra kết quả

Kiểm tra danh sách Pod:

```bash
kubectl get po
```

Pod `hello-nginx` sẽ xuất hiện trong danh sách. Có thể xem riêng Pod này bằng:

```bash
kubectl get po hello-nginx
```

Xem log của container Nginx:

```bash
kubectl logs hello-nginx
```

Thực thi shell bên trong container:

```bash
kubectl exec -it hello-nginx -- /bin/sh
```

Gõ `exit` để thoát khỏi container.

## Dọn dẹp tài nguyên

Xóa Pod sau khi hoàn thành lab:

```bash
kubectl delete po hello-nginx
```

## Ghi chú

- `po` là tên viết tắt của resource `pod` trong `kubectl`.
- Đây là Pod độc lập, không được quản lý bởi Deployment. Sau khi xóa bằng
  `kubectl delete po`, Pod sẽ không tự động được tạo lại.
- Log Nginx có thể chưa có nội dung nếu Pod chưa nhận request.
