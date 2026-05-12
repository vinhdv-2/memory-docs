****************************************
- Máy chủ tương tự các loại máy tính, điện thoại, tablet, thiết bị thông minh khác,... có disk, ram, cpu, card,... nhưng khác biệt ở độ tin cậy và sự chịu tải do nó chứa đựng cấu hình khủng để xử lý nhiều tiến trình tính toán khổng lồ, hoạt động liên tục trong thời gian dài.

- Public IP: IP là địa chỉ định danh, muốn có danh phận trên bản đồ internet cần có một địa chỉ định danh. Để public được, cần thuê đường truyền từ các nhà cung cấp dịch vụ internet (ISP) và yêu cầu các IP. Khi đã có IP, thì có thể tìm kiếm ở bất kỳ đâu thông qua internet.

- Domain (tên miền): cũng là địa chỉ định danh, nó thường được sử dụng tìm kiếm hơn là tìm kiếm bằng IP. Nó là sự đơn giản trực quan hóa về địa chỉ máy chủ cần tìm kiếm. Suy cho cùng nhập domain request gửi chúng đến DNS chúng sẽ phân giải tên miền thành địa chỉ IP và gửi request đến địa chỉ IP đó.

- Mạng LAN/VLAN: Mạng nội bộ quản lý các máy chủ trong một mạng riêng. Các máy ngoài mạng nội bộ muốn truy cập đến máy chủ trong mạng nội bộ, chúng cần thông qua VPN để giả lập như bản thân ở trong mạng nội bộ đó.

- Các doanh nghiệp công ty tự build các máy chủ để phát triển phần mềm, thử nghiệm các môi trường khác nhau như dev, stg, trial,... mỗi máy chủ có mục đích riêng của nó. Họ thiết lập mạng nội bộ để đảm bảo mọi người trong nội bộ có thể kết nối với nhau nhưng cũng đảm bảo tách biệt với môi trường bên ngoài.

- Tôi mong muốn tìm hiểu kiến trúc cơ sở hạ tầng công nghệ, cách chúng hoạt động, vận hành. Nhưng tôi không có chi phí cho việc build một máy chủ riêng có cấu hình phức tạp, cũng không có chi phí cho thuê cloud. Tôi sẽ thực hiện chúng ngay trên máy cá nhân, bằng cách tạo ra một môi trường ảo hóa, cô lập chúng với môi trường hiện tại để thực hiện các thử nghiệm. Chúng không thể so sánh với các môi trường kia, nhưng trong phạm vi hạn chế tôi sẽ cố gắng mô phỏng chúng giống hết mức có thể.

- Luồng đi 1 request : user nhập thông tin -> máy tính xử lý tính toán tạo request -> browser gửi request -> dns phân giải request, tên miền thành địa chỉ IP và gửi request đến địa chỉ máy chủ xử lý -> CDN tính toán kiểm tra cache ? -> máy chủ tiếp nhận request -> Các lớp trong máy chủ xử lý firewall -> reverse proxy/load balancer -> web server -> ứng dụng -> db or cache -> sau khi có kết quả chúng đi ngược lại để trả kết quả về client cuối

* Quá trình thiết lập
  * Cài đặt máy ảo và môi trường ảo https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview
  * Cài đặt tối thiểu 1 vsm vì không đủ tài nguyên cấu hình, vấn đề chứng chỉ bảo mật ssl và domain custom /etc/hosts để setup domain ảo về IP máy ảo. Sử dụng mkcert để tạo chứng chỉ self-signed cho môi trường nội bộ, trình duyệt sẽ nhận diện nó như sercure thật
  * Sau khi thiết lập xong, mở cli cài đặt ssh server để nơi khác có thể ssh remote
  * Mở cấu hình setting, phần network sửa adapter, attach loại nat, port forwarding thêm rule ssh|TCP|127.0.0.1|2222||22. Sau đó thực hiện restart or reload lại là có thể sử dụng máy local remote ssh tới
  Hoặc cấu hình bridged adapter nó giống như VM một máy riêng trong LAN, nhưng VM cần có IP riêng trong mạng nội bộ
  * Tạo ssh key cho vsm và paste chúng vào github để dùng sau
  * CI/CD với github (nơi chứa source), máy ảo nằm sau router nội bộ, github không thể gọi về máy được. Cần pull mechanism đó là cài đặt github action self-hosted runner lên máy ảo. Runner này chủ động lắng nghe github, khi có code mới nó sẽ thực hiện kéo về build, ko cần mở port modem. Hoặc sử dụng webhook tunnel như ngrok hoặc cloudflare tunnerl để tạo pipe từ internet về máy ảo. Chọn cách 1
  * Login github, truy cập dự án muốn thực hiện, setting > action > runner > new self-hosted runner thiết lập cấu hình cho máy linux x64 lấy thông tin cấu hình token sau đó thiết lập nó trên máy ảo
  * Trên máy ảo tải một số công cụ cần thiết như git, docker,... phân quyền để runner để sử dụng.
  * Ở source tạo các file CI|CD, docker-compose.yml, workflow deploy để định nghĩa các bước thực thi.
  * Sau khi hoàn tất tiến hành test thử bằng cách push code lên branch chỉ định trigger workflow deploy. Nếu deploy thành công, truy cập web bằng port 8090. Sử dụng link public IP để truy cập


*************************
- Jenkins và GitHub Actions Runner đều là công cụ phục vụ cho CI/CD — tức là tự động hóa quy trình build, test, deploy phần mềm.
Nói đơn giản: thay vì dev phải tự tay chạy script build, test code, đóng gói Docker image, SSH lên server deploy..., thì mấy công cụ này làm hộ theo workflow định sẵn.

* Flow làm việc thường thấy của jenkins
  * Dev push code lên GitHub/GitLab
  * Jenkins theo dõi và phát hiện có thay đổi như khi có commit/push/pull request thì trigger job
  * chạy các pipeline/script bạn định nghĩa như:
    * pull code mới
    * lint code
    * security scan
    * cài dependencies
    * chạy test
    * build project
    * build Docker image
    * push image lên registry
    * deploy lên server staging/production

* Mục tiêu phát hiện lỗi sớm, đảm bảo các quy trình an toàn, tự động, chuẩn hóa cao, tiết kiệm tài nguyên xử lý thủ công
* Mục đích khác: backup database, sync file, chạy cron jobs, maintenance server, build tài liệu, clear cache, rotate logs, restore system
******** Cơ bản là nó cho phép theo dõi một đối tượng, chỉ định hành vi phản ứng với sự thay đổi đó, tự động thực hiện các kịch bản đã thiết lập từ trước 

- GitHub Actions Runner tương tự jenkins nó phục vụ cho CI/CD của github
- Cách cài đặt và sử dụng: thay vì cài đặt như jenkins thì nó viết workflow YAML trong repo .github/workflows/deploy.yml

