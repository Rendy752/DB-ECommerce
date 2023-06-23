delimiter <>
create or replace trigger register 
before insert on pengguna for each row
begin
declare cekUsername int;
declare cekNoTelp int;
declare cekEmail int;
set cekUsername=(select username from pengguna where username= new.username);
set cekNoTelp=(select noTelp from pengguna where noTelp= new.noTelp);
set cekEmail=(select email from pengguna where email=new.Email);
if (cekNoTelp is null and new.noTelp is not null) then
	if(cekUsername is null) then
		if(char_length(new.password)<8) then
			signal sqlstate '44444' set message_text = 'Password minimal 8 digit!!';
		else
			set new.id = uuid();
			set new.password=password(new.password);
			set new.level=1;
		end if;
	else
		signal sqlstate '44444' set message_text = 'Username telah diambil, silahkan ganti yang lain';
	end if;
elseif(cekEmail is null and new.email is not null) then
	if(cekUsername is null) then
		if(char_length(new.password)<8) then
			signal sqlstate '44444' set message_text = 'Password minimal 8 digit!!';
		else
			set new.id = uuid();
			set new.password=password(new.password);
			set new.level=1;
		end if;
	else
		signal sqlstate '44444' set message_text = 'Username telah diambil, silahkan ganti yang lain';
	end if;
else
	signal sqlstate '44444' set message_text = 'Nomor telepon atau email sudah terdaftar';
end if;
end <>
delimiter ;

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`, `email`, `password`, `pin`) VALUES 
('Ilham', 'ilhamz','08129022310', 'ilham@gmail.com', 'ilham7580', '7580');
INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `email`, `password`) VALUES 
('Ilham', 'gogo', 'ilham@gmail.com', 'ilham7580');-- email sama
INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`, `password`) VALUES 
('Ilham', 'alhim','08129022310', 'ilham7580');-- no telepon sama
INSERT INTO `shop`.`pengguna` (`namaLengkap`, `noTelp`, `password`) VALUES 
('Laura', '085367818912', 'laura12');-- password <8 digit
INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`,`email`, `password`) VALUES 
('Laura', 'ilhamz','085367818912', 'Laura22@gmail.com','laura123'); -- email, no telp baru tpi username sama
INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`,`email`, `password`) VALUES 
('Laura', 'lauraz','085367818912', 'Laura22@gmail.com','laura123'); 
INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`,`email`, `password`, `pin`) VALUES 
('Budi', 'budiz','0846635353553', 'budi343@gmail.com','budi6565','6565');
INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`,`email`, `password`, `pin`) VALUES 
('Lilia', 'liliaz','084873847384', 'lilia444@gmail.com','lilia6565','4444');
select*from pengguna;

delimiter <>
create trigger addKategori
before insert on kategori for each row
begin
declare cekKategori int;
set cekKategori=(select nama from kategori where nama=new.nama);
if(cekKategori is not null) then
	signal sqlstate '44444' set message_text = 'Kategori sudah ada!!';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Elektronik');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Fashion');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Elektronik');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Perfume');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Accesories');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Fashion'); -- kategori sudah ada
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Alat Dapur');
select*from kategori;

delimiter <>
create or replace trigger addPelapak
before insert on pelapak for each row
begin
declare cekPelapak int;
set cekPelapak=(select nama from pelapak where nama=new.nama and lokasi=new.lokasi);
if(cekPelapak is not null) then
	signal sqlstate '44444' set message_text = 'Pelapak dengan lokasi yang sama sudah ada, tidak bisa menambah data';
end if;
set new.id = uuid();
set new.rating=0;
end <>
delimiter ;

INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Asus Official', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Zara', 'Bandung');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Asus Official', 'Jakarta'); -- pelapak dengan lokasi sama
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Indonesia Merk', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Xyz Shop', 'Bandung');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('H&M', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Gucci', 'Kalimantan');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Sonny Official','Semarang');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Samsung Official', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Nike', 'Bogor');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Origin Aksesoris Hp', 'Jakarta Pusat');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Grotic', 'Tangerang');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Caselova Store', 'Bekasi');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Batik Shop', 'Surabaya');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Atmosphere Collection', 'Depok');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Figi Retail Grosir', 'Jakarta Pusat');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Pusat Photography', 'Bekasi');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Vivan Cell', 'Jakarta Timur');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('CamLab', 'Jakarta Utara');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES ('Januari', 'Jakarta Selatan');
select*from pelapak;

delimiter <>
create or replace trigger addMetodePembayaran
before insert on metodePembayaran for each row
begin
declare cekMetodePembayaran int;
set cekMetodePembayaran=(select nama from MetodePembayaran where nama=new.nama);
if(cekMetodePembayaran is not null) then
	signal sqlstate '44444' set message_text = 'Metode pembayaran sudah ada, tidak dapat menambah data';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`metodePembayaran` (`nama`) VALUES ('OVO');
INSERT INTO `shop`.`metodePembayaran` (`nama`) VALUES ('BCA');
INSERT INTO `shop`.`metodePembayaran` (`nama`) VALUES ('OVO'); -- metode pembayaran sudah ada
INSERT INTO `shop`.`metodePembayaran` (`nama`) VALUES ('GoPay');
INSERT INTO `shop`.`metodePembayaran` (`nama`) VALUES ('ShopeePay');
INSERT INTO `shop`.`metodePembayaran` (`nama`) VALUES ('DANA');
select*from metodePembayaran;

delimiter <>
create or replace trigger addPromo
before insert on promo for each row
begin
declare cekPromo int;
set cekPromo=(select nama from promo where nama=new.nama);
if(new.berlakuHingga<date(now())) then
	signal sqlstate '44444' set message_text = 'Tanggal berlaku sudah lewat, tidak dapat menambah data';
elseif(cekPromo is not null) then
	signal sqlstate '44444' set message_text = 'Promo sudah ada, tidak dapat menambah data';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `diskon`,`levelPengguna`,`berlakuHingga`) VALUES 
('Promo Lebaran', 'Diskon 20% untuk semua produk', 100000, 20, 1,'2023-06-19'); -- tanggal berlaku lewat
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `diskon`,`levelPengguna`,`berlakuHingga`) VALUES 
('Promo Lebaran', 'Diskon 20% untuk semua produk', 100000, 20, 1,'2023-07-19');
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `diskon`, `levelPengguna`,`berlakuHingga`) VALUES 
('Promo Natal', 'Diskon 10% untuk semua produk', 200000, 10, 2,'2023-08-30');
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `diskon`, `levelPengguna`,`berlakuHingga`) VALUES 
('Promo Lebaran', 'Diskon 30% untuk semua produk', 100000, 30, 1,'2023-08-30'); -- nama promo sama
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `diskon`, `levelPengguna`,`berlakuHingga`) VALUES 
('Promo Lebaran 2', 'Diskon 30% untuk semua produk', 150000, 30, 1,'2023-08-30');
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `diskon`, `levelPengguna`,`berlakuHingga`) VALUES 
('Promo 6.6', 'Diskon 20% untuk semua produk', 400000, 20, 3,'2023-10-30');
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `diskon`, `levelPengguna`,`berlakuHingga`) VALUES 
('Promo Potongan', 'Diskon 10% Potongan Untuk Produk Yang Dpilih', 0, 10, 1,'2023-08-15');
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `diskon`, `levelPengguna`,`berlakuHingga`) VALUES 
('Promo Tahun Baru', 'Diskon 40% untuk semua produk', 200000, 40, 3,'2023-11-30');
select*from promo;

delimiter <>
create or replace trigger addPromoPelapak
before insert on promoPelapak for each row
begin
declare cekPromo char(36);
declare varIdPelapak char(36);
set varIdPelapak=(select id from pelapak where nama=new.idPelapak);
set cekPromo=(select count(*) from promoPelapak where idPelapak=varIdPelapak and nama=new.nama);
if(varIdPelapak is null) then
	signal sqlstate '44444' set message_text = 'Pelapak tidak diketahui, tidak dapat menambah data';
elseif(new.berlakuHingga<date(now())) then
	signal sqlstate '44444' set message_text = 'Tanggal berlaku sudah lewat, tidak dapat menambah data';
elseif(cekPromo!=0) then
	signal sqlstate '44444' set message_text = 'Promo sudah ada, tidak dapat menambah data';
end if;
set new.id = uuid();
set new.idPelapak=varIdPelapak;
end <>
delimiter ;

INSERT INTO `shop`.`promoPelapak` (`idPelapak`,`nama`, `deskripsi`, `minTransaksi`, `diskon`,`berlakuHingga`) VALUES 
('Zoro','Potongan harga', 'Diskon 10% untuk semua produk', 100000, 10,'2023-08-15'); -- pelapak tidak diketahui
INSERT INTO `shop`.`promoPelapak` (`idPelapak`,`nama`, `deskripsi`, `minTransaksi`, `diskon`,`berlakuHingga`) VALUES 
('Zara','Potongan harga', 'Diskon 10% untuk semua produk', 100000, 10,'2022-12-30');
INSERT INTO `shop`.`promoPelapak` (`idPelapak`,`nama`, `deskripsi`, `minTransaksi`, `diskon`,`berlakuHingga`) VALUES 
('Zara','Potongan harga', 'Diskon 10% untuk semua produk', 100000, 10,'2023-12-30');
INSERT INTO `shop`.`promoPelapak` (`idPelapak`,`nama`, `deskripsi`, `minTransaksi`, `diskon`,`berlakuHingga`) VALUES 
('Zara','Potongan harga', 'Diskon 10% untuk semua produk', 100000, 10,'2023-08-30'); -- promo sudah ada di pelapak yang sama
INSERT INTO `shop`.`promoPelapak` (`idPelapak`,`nama`, `deskripsi`, `minTransaksi`, `diskon`,`berlakuHingga`) VALUES 
('Asus Official','Promo Lebaran', 'Diskon 20% untuk semua produk', 100000, 20,'2023-10-30');
INSERT INTO `shop`.`promoPelapak` (`idPelapak`,`nama`, `deskripsi`, `minTransaksi`, `diskon`,`berlakuHingga`) VALUES 
('Sonny Official','Potongan harga', 'Diskon 15% untuk semua produk', 120000, 15,'2023-09-30');
select*from promoPelapak;


delimiter <>
create or replace trigger addAlamat
before insert on alamat for each row
begin
declare varIdPengguna char(36);
declare cekAlamat int;
set varIdPengguna=(select id from pengguna where username=new.idPengguna);
set cekAlamat=(select count(*) from alamat where idPengguna=varIdPengguna and alamat=new.alamat);
if(varIdPengguna is null) then
	signal sqlstate '44444' set message_text = 'Pengguna tidak diketahui, tidak dapat menambah data';
elseif(cekAlamat!=0) then
	signal sqlstate '44444' set message_text = 'Alamat sudah ada, tidak dapat menambah data';
end if;
set new.id = uuid();
set new.idPengguna=varIdPengguna;
end <>
delimiter ;

INSERT INTO `shop`.`alamat` (`idPengguna`, `alamat`, `alamatSebagai`, `namaPenerima`, `noTelp`, `kecamatan`, `kota`, `provinsi`, `kodePos`) values
('ilhamz','Jl. Rambutan No. 123', 'rumah', 'Ilham', '08129022310', 'Kec. Rambutan', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32511);
INSERT INTO `shop`.`alamat` (`idPengguna`, `alamat`, `alamatSebagai`, `namaPenerima`, `noTelp`, `kecamatan`, `kota`, `provinsi`, `kodePos`) values
('budiz','Jl. Mangga No. 456', 'kantor', 'Citra', '087638172311', 'Kec. Mangga', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32512);
INSERT INTO `shop`.`alamat` (`idPengguna`, `alamat`, `alamatSebagai`, `namaPenerima`, `noTelp`, `kecamatan`, `kota`, `provinsi`, `kodePos`) values
('lauraz','Jl. Rambutan No. 124', 'rumah', 'Santoso', '08878797979', 'Kec. Rambutan', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32511);
INSERT INTO `shop`.`alamat` (`idPengguna`, `alamat`, `alamatSebagai`, `namaPenerima`, `noTelp`, `kecamatan`, `kota`, `provinsi`, `kodePos`) values
('laurazz','Jl. Apel No. 789', 'rumah', 'Laura', '085367818912', 'Kec. Apel', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32513); -- id pengguna tidak diketahui
INSERT INTO `shop`.`alamat` (`idPengguna`, `alamat`, `alamatSebagai`, `namaPenerima`, `noTelp`, `kecamatan`, `kota`, `provinsi`, `kodePos`) values
('budiz','Jl. Mangga No. 456', 'rumah', 'Windah', '085378908716', 'Kec. Jeruk', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32514); -- alamat sudah ada di pengguna yang sama
INSERT INTO `shop`.`alamat` (`idPengguna`, `alamat`, `alamatSebagai`, `namaPenerima`, `noTelp`, `kecamatan`, `kota`, `provinsi`, `kodePos`) values
('lauraz','Jl. Manggis No. 202', 'rumah', 'Windah', '085379809112', 'Kec. Manggis', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32515);
INSERT INTO `shop`.`alamat` (`idPengguna`, `alamat`, `alamatSebagai`, `namaPenerima`, `noTelp`, `kecamatan`, `kota`, `provinsi`, `kodePos`) values
('ilhamz','Jl. Apel No. 789', 'rumah', 'Edi', '085367818912', 'Kec. Apel', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32513);
select*from alamat;

delimiter <>
create or replace trigger addMetodePembayaranTerhubung
before insert on metodePembayaranTerhubung for each row
begin
declare varIdPengguna char(36);
declare varIdMetodePembayaran char(36);
declare cekMetodePembayaranPengguna int;
set varIdPengguna=(select id from pengguna where username=new.idPengguna);
set varIdMetodePembayaran=(select id from MetodePembayaran where nama=new.idMetodePembayaran);
set cekMetodePembayaranPengguna=(select count(*) from metodePembayaranTerhubung where idPengguna=varIdPengguna and idMetodePembayaran=varIdMetodePembayaran);
if(varIdPengguna is null) then
	signal sqlstate '44444' set message_text = 'Pengguna tidak diketahui, tidak dapat menambah data';
elseif(varIdMetodePembayaran is null) then
	signal sqlstate '44444' set message_text = 'Metode pembayaran tidak diketahui, tidak dapat menambah data';
elseif(cekMetodePembayaranPengguna!=0) then
	signal sqlstate '44444' set message_text = 'Pengguna sudah memiliki metode pembayaran terkait';
end if;
set new.idPengguna=varIdPengguna;
set new.idMetodePembayaran=varIdMetodePembayaran;
end <>
delimiter ;

INSERT INTO `shop`.`metodePembayaranTerhubung` (`idPengguna`, `idMetodePembayaran`) values ('susanto','ovo'); -- pengguna tidak diketahui
INSERT INTO `shop`.`metodePembayaranTerhubung` (`idPengguna`, `idMetodePembayaran`) values ('ilhamz','ShopeePay'); -- metode pembayaran tidak diketahui
INSERT INTO `shop`.`metodePembayaranTerhubung` (`idPengguna`, `idMetodePembayaran`) values ('ilhamz','ovo');
INSERT INTO `shop`.`metodePembayaranTerhubung` (`idPengguna`, `idMetodePembayaran`) values ('ilhamz','ovo'); -- metode pembayaran sudah ada di pengguna yang sama
INSERT INTO `shop`.`metodePembayaranTerhubung` (`idPengguna`, `idMetodePembayaran`) values ('ilhamz','dana');
INSERT INTO `shop`.`metodePembayaranTerhubung` (`idPengguna`, `idMetodePembayaran`) values ('lauraz','dana');
INSERT INTO `shop`.`metodePembayaranTerhubung` (`idPengguna`, `idMetodePembayaran`) values ('budiz','bca');
INSERT INTO `shop`.`metodePembayaranTerhubung` (`idPengguna`, `idMetodePembayaran`) values ('budiz','gopay');
INSERT INTO `shop`.`metodePembayaranTerhubung` (`idPengguna`, `idMetodePembayaran`) values ('budiz','shopeepay');
select*from metodePembayaranTerhubung;

delimiter <>
create or replace trigger addProduk
before insert on produk for each row
begin
declare varIdKategori char(36);
declare varIdPelapak char(36);
declare cekProduk int;
set varIdKategori=(select id from kategori where nama=new.idKategori);
set varIdPelapak=(select id from pelapak where nama=new.idPelapak);
set cekProduk=(select count(*) from produk where nama=new.nama);
if(varIdKategori is null) then
	signal sqlstate '44444' set message_text = 'Kategori tidak diketahui, tidak dapat menambah data';
elseif(varIdPelapak is null) then
	signal sqlstate '44444' set message_text = 'Pelapak tidak diketahui, tidak dapat menambah data';
elseif(cekProduk!=0) then
	signal sqlstate '44444' set message_text = 'Produk sudah ada, tidak dapat menambah data';
else
	if((select locate(",",new.nama))!=0) then
		signal sqlstate '44444' set message_text = 'Nama produk tidak boleh mengandung koma, tidak dapat menambah data';
	elseif(new.kondisi not in("Baru","Lama","Bekas")) then
		signal sqlstate '44444' set message_text = 'Kondisi tidak diketahui, tidak dapat menambah data';
	elseif(new.asal not in("Lokal","Impor")) then
		signal sqlstate '44444' set message_text = 'Asal tidak diketahui, tidak dapat menambah data';
	else
		set new.id=uuid();
		set new.idPelapak=varIdPelapak;
		set new.idKategori=varIdKategori;
		set new.rating=0;
		set new.ulasan=0;
		set new.terjual=0;
	end if;
end if;
end <>
delimiter ;

INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'laptop official','Laptop Asus ZenForce', 20,'Baru', 2000, 'Lokal', 'Laptop Asus Zenforce Ram 12GB', 7000000); -- kategori / pelapak tidak ada
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik','asus official','Laptop Asus ZenForce', 20,'Baru', 2000, 'Lokal', 'Laptop Asus Zenforce Ram 12GB', 7000000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('fashion', 'zara', 'Kemeja Denim, ukuran M', 50, 'sangat baru', 100, 'lokal', 'Kemeja Denim Pria Ukuran M', 350000); -- nama tidak boleh koma
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('fashion', 'zara', 'Kemeja Denim', 50, 'sangat baru', 100, 'lokal', 'Kemeja Denim Pria Ukuran M', 350000); -- kondisi tidak diketahui
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('fashion', 'zara', 'Kemeja Denim', 50, 'baru', 100, 'ekspor', 'Kemeja Denim Pria Ukuran M', 350000); -- asal tidak diketahui
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('fashion', 'zara','Kemeja Denim', 50, 'baru', 100, 'lokal', 'Kemeja Denim Pria Ukuran M', 350000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('fashion',' h&m', 'Celana Jeans Slim Fit', 40, 'baru', 200, 'lokal', 'Celana Jeans Slim Fit Warna Biru', 250000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('fashion', 'nike', 'Sepatu Nike Running', 45, 'baru', 500, 'impor', 'Sepatu Nike Running Pria', 800000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'sonny official', 'Headphone Sony', 25, 'baru', 300, 'impor', 'Headphone Sony Noise-Canceling', 1200000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('perfume', 'zara', 'Carolina Herera', 0, 'bekas', 350, 'impor', 'Jasmine scent, long lasting perfume with an unexpected twist of sensuality and mystery', 900000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Origin Aksesoris Hp', 'Headphone Bluetooth airpods', 40, 'baru', 150, 'lokal', 'Suara mantap, bisa wireless charging', 110000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Grotic', 'Grotic TWS Headphone Gaming', 14, 'baru', 200, 'lokal', 'Gaming mode, low latency 40-60ms', 158000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Caselova Store', 'Headphone Bluetooth S109 Earphone Wireless', 14, 'baru', 50, 'lokal', 'Desain ramping dan ringan', 17900);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Batik Shop', 'I7S TWS Headphone Airpods Bluetooth Wireless', 148, 'baru', 200, 'lokal', 'Bisa pakai wireless, untuk apa menggunakan kabel?', 30600);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Atmosphere Collection', 'Headphone pro 4 mini TWS Wireless Nirkabel Stereo Hifi Sport', 50, 'baru', 400, 'lokal', 'Kompatibel untuk android, iphone, ipad', 84270);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Figi Retail Grosir', 'Gaming Headphone Wireless Super Bass', 7, 'baru', 1200, 'lokal', 'Nikmati pengalaman bermain game yang seru dengan ini', 681000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Figi Retail Grosir', 'Microphone Headphone Mini Portable Tour Guide UHF', 5, 'baru', 350, 'lokal', 'Mentransmit suara melalui sinyal UHF dari frekuensi 630-690 MHz', 274000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Pusat Photography', 'Motivo W18 TWS Headphone Bluetooth 5.3 Wireless', 10, 'baru', 300, 'lokal', 'Buds telinga stereo', 449900);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Vivan Cell', 'Headphone XIAOMI Handsfree BT', 200, 'baru', 50, 'lokal', 'No komplain, no retur', 12500);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'CamLab', 'Saramonic WiTalk WT5D Wireless Intercom Headphone', 3000, 'baru', 50, 'lokal', 'Two-way communication at a range of up to 400m', 29500000);
INSERT INTO `shop`.`produk` (`idKategori`, `idPelapak`, `nama`, `stok`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`) VALUES 
('elektronik', 'Januari', 'Steelseries Arctis Nova Pro Wireless GameDAC Gaming Headphone', 2000, 'baru', 50, 'lokal', 'Bonus merchandise exclusive(gantungan kunci/stiker)', 8624000);
select*from produk;

delimiter <>
create or replace trigger addProdukFavorit
before insert on produkFavorit for each row
begin
declare varIdPengguna char(36);
declare varIdProduk char(36);
declare cekProdukFavorit int;
set varIdPengguna=(select id from pengguna where username=new.idPengguna);
set varIdProduk=(select id from produk where nama=new.idProduk);
set cekProdukFavorit=(select count(*) from produkFavorit where idPengguna=varIdPengguna and idProduk=varIdProduk);
if(varIdPengguna is null) then
	signal sqlstate '44444' set message_text = 'Pengguna tidak diketahui, tidak dapat menambah data';
elseif(varIdProduk is null) then
	signal sqlstate '44444' set message_text = 'Produk tidak diketahui, tidak dapat menambah data';
elseif(cekProdukFavorit!=0) then
	signal sqlstate '44444' set message_text = 'Produk sudah dalam list favorit, tidak dapat menambah data';
else
	set new.idPengguna=varIdPengguna;
    set new.idProduk=varIdProduk;
end if;
end <>
delimiter ;

INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('tono','Headphone Sony'); -- pengguna tidak diketahuu
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Headphone Asus'); -- produk tidak diketahui
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Headphone Sony');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Kemeja Denim');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Kemeja Denim'); -- produk sudah ada di list pengguna yang sama
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Sepatu Nike Running');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('lauraz','Kemeja Denim');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('budiz','Kemeja Denim');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('liliaz','Kemeja Denim');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('budiz','Sepatu Nike Running');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('liliaz','Headphone Sony');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Laptop Asus ZenForce');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('lauraz','Headphone Sony');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Carolina Herera');
select*from produkFavorit;

delimiter <>
create or replace trigger addKeranjang
before insert on keranjang for each row
begin
declare varIdPengguna char(36);
declare varIdProduk char(36);
declare cekKeranjang int;
declare cekStok int;
set varIdPengguna=(select id from pengguna where username=new.idPengguna);
set varIdProduk=(select id from produk where nama=new.idProduk);
set cekKeranjang=(select count(*) from keranjang where idPengguna=varIdPengguna and idProduk=varIdProduk);
set cekStok=(select stok from produk where id=varIdProduk);
if(varIdPengguna is null) then
	signal sqlstate '44444' set message_text = 'Pengguna tidak diketahui, tidak dapat menambah data';
elseif(varIdProduk is null) then
	signal sqlstate '44444' set message_text = 'Produk tidak diketahui, tidak dapat menambah data';
elseif(cekKeranjang!=0) then
	signal sqlstate '44444' set message_text = 'Produk sudah dalam list keranjang, tidak dapat menambah data';
elseif(cekStok=0) then
	signal sqlstate '44444' set message_text = 'Stok kosong, tidak dapat menambah data';
elseif(new.jumlah>cekStok) then
	signal sqlstate '44444' set message_text = 'Stok tidak tersedia, tidak dapat menambah data';
else
	set new.idPengguna=varIdPengguna;
    set new.idProduk=varIdProduk;
end if;
end <>
delimiter ;

INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('tono','Headphone Sony',20); -- pengguna tidak diketahui
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Headphone Asus',30); -- produk tidak diketahui
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Carolina Herera',40); -- stok barang kosong
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Kemeja Denim',51); -- stok tidak tersedia
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Kemeja Denim',30);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Kemeja Denim',1); -- produk sudah ada di keranjang pengguna yang sama
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Sepatu Nike Running',20);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('lauraz','Kemeja Denim',2);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('budiz','Headphone Sony',5);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('liliaz','Headphone Sony',20);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('budiz','Sepatu Nike Running',1);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('liliaz','Laptop Asus ZenForce',1);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Laptop Asus ZenForce',2);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('lauraz','Headphone Sony',3);
select*from keranjang;

delimiter <>
create or replace trigger addKurir
before insert on kurir for each row
begin
declare cekKurir int;
set cekKurir=(select nama from kurir where nama=new.nama);
if(cekKurir is not null) then
	signal sqlstate '44444' set message_text = 'Kurir sudah ada, tidak dapat menambah data';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`kurir` (`nama`,`ongKir`) VALUES ('BukaExpress REG',27500);
INSERT INTO `shop`.`kurir` (`nama`,`ongKir`) VALUES ('BukaExpress REG',27500); -- kurir sudah ada
INSERT INTO `shop`.`kurir` (`nama`,`ongKir`) VALUES ('J&T REG',22500);
INSERT INTO `shop`.`kurir` (`nama`,`ongKir`) VALUES ('SiCepat REG',27500);
INSERT INTO `shop`.`kurir` (`nama`,`ongKir`) VALUES ('SiCepat HALU',19000);