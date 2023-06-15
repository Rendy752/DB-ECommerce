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
			signal sqlstate '44444'
			set message_text = 'Password minimal 8 digit!!';
		else
			set new.id = uuid();
			set new.password=password(new.password);
			set new.level=1;
		end if;
	else
		signal sqlstate '44444'
		set message_text = 'Username telah diambil, silahkan ganti yang lain';
	end if;
elseif(cekEmail is null and new.email is not null) then
	if(cekUsername is null) then
		if(char_length(new.password)<8) then
			signal sqlstate '44444'
			set message_text = 'Password minimal 8 digit!!';
		else
			set new.id = uuid();
			set new.password=password(new.password);
			set new.level=1;
		end if;
	else
		signal sqlstate '44444'
		set message_text = 'Username telah diambil, silahkan ganti yang lain';
	end if;
else
	signal sqlstate '44444'
	set message_text = 'Nomor telepon atau email sudah terdaftar';
end if;
end <>
delimiter ;
select*from pengguna;
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
	signal sqlstate '44444'
	set message_text = 'Kategori sudah ada!!';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Elektronik');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Fashion');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Elektronik');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Perfume');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Accesories');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('fashion');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Alat Dapur');
select*from kategori;

delimiter <>
create or replace trigger addPelapak
before insert on pelapak for each row
begin
declare cekPelapak int;
set cekPelapak=(select nama from pelapak where nama=new.nama and lokasi=new.lokasi);
if(cekPelapak is not null) then
	signal sqlstate '44444'
	set message_text = 'Pelapak dengan lokasi yang sama sudah ada, tidak bisa menambah data';
end if;
set new.id = uuid();
set new.rating=0;
end <>
delimiter ;

INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Asus Official', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Zara', 'Bandung');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Asus Official', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Indonesia Merk', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Xyz Shop', 'Bandung');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('H&M', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Gucci', 'Kalimantan');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Sonny Official','Semarang');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Samsung Official', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Samsung Official', 'Jakarta');
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`) VALUES 
('Nike', 'Bogor');
select*from pelapak;

delimiter <>
create trigger addDompetDigital
before insert on dompetdigital for each row
begin
declare cekDompetDigital int;
set cekDompetDigital=(select nama from dompetdigital where nama=new.nama);
if(cekDompetDigital is not null) then
	signal sqlstate '44444'
	set message_text = 'Dompet digital sudah ada, tidak dapat menambah data';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('OVO');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('OVO');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('BCA');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('GoPay');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('ShopeePay');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('DANA');
select*from dompetdigital;

delimiter <>
create or replace trigger addPromo
before insert on promo for each row
begin
declare cekPromo int;
set cekPromo=(select nama from promo where nama=new.nama and minTransaksi=new.minTransaksi);
if(cekPromo is not null) then
	signal sqlstate '44444'
	set message_text = 'Promo sudah ada, tidak dapat menambah data';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Lebaran', 'Diskon 20% untuk semua produk', 100000, 1);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Natal', 'Diskon 10% untuk semua produk', 200000, 2);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Lebaran', 'Diskon 30% untuk semua produk', 100000, 1);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Lebaran', 'Diskon 30% untuk semua produk', 150000, 1);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo 6.6', 'Diskon 20% untuk semua produk', 400000, 3);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Potongan', 'Diskon 10% Potongan Untuk Produk Yang Dpilih', 0, 1);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Tahun Baru', 'Diskon 40% untuk semua produk', 200000, 3);
select*from promo;

delimiter <>
create or replace trigger addAlamat
before insert on alamat for each row
begin
declare varIdPengguna char(36);
declare cekAlamat int;
set varIdPengguna=(select id from pengguna where username=new.idPengguna);
set cekAlamat=(select count(*) from alamat where idPengguna=varIdPengguna and alamat=new.alamat);
if(varIdPengguna is null) then
	signal sqlstate '44444'
	set message_text = 'Pengguna tidak diketahui, tidak dapat menambah data';
elseif(cekAlamat!=0) then
	signal sqlstate '44444'
	set message_text = 'Alamat sudah ada, tidak dapat menambah data';
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
create or replace trigger addDompetTerhubung
before insert on dompetTerhubung for each row
begin
declare varIdPengguna char(36);
declare varIdDompetDigital char(36);
declare cekDompetPengguna int;
set varIdPengguna=(select id from pengguna where username=new.idPengguna);
set varIdDompetDigital=(select id from dompetDigital where nama=new.idDompet);
set cekDompetPengguna=(select count(*) from dompetTerhubung where idPengguna=varIdPengguna and idDompet=varIdDompetDigital);
if(varIdPengguna is null or varIdDompetDigital is null) then
	signal sqlstate '44444'
	set message_text = 'Pengguna atau dompet digital tidak diketahui, tidak dapat menambah data';
elseif(cekDompetPengguna!=0) then
	signal sqlstate '44444'
	set message_text = 'Pengguna sudah memiliki dompet terkait';
end if;
set new.idPengguna=varIdPengguna;
set new.idDompet=varIdDompetDigital;
end <>
delimiter ;

select*from pengguna;
select*from dompetdigital;
select*from dompetTerhubung;

INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`) values ('susanto','ovo');
INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`) values ('ilhamz','bri');
INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`) values ('ilhamz','ovo');
INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`) values ('ilhamz','dana');
INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`) values ('lauraz','dana');
INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`) values ('budiz','bca');
INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`) values ('budiz','gopay');
INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`) values ('budiz','shopeepay');

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
if(varIdKategori is null or varIdPelapak is null) then
	signal sqlstate '44444'
	set message_text = 'Kategori atau pelapak tidak diketahui, tidak dapat menambah data';
elseif(cekProduk!=0) then
	signal sqlstate '44444'
	set message_text = 'Produk sudah ada, tidak dapat menambah data';
else
	if(new.kondisi not in("Baru","Lama","Bekas")) then
		signal sqlstate '44444'
		set message_text = 'Kondisi tidak diketahui, tidak dapat menambah data';
	elseif(new.asal not in("Lokal","Impor")) then
		signal sqlstate '44444'
		set message_text = 'Asal tidak diketahui, tidak dapat menambah data';
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
select*from produk;
select*from kategori;
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
	signal sqlstate '44444'
	set message_text = 'Pengguna tidak diketahui, tidak dapat menambah data';
elseif(varIdProduk is null) then
	signal sqlstate '44444'
	set message_text = 'Produk tidak diketahui, tidak dapat menambah data';
elseif(cekProdukFavorit!=0) then
	signal sqlstate '44444'
	set message_text = 'Produk sudah dalam list favorit, tidak dapat menambah data';
else
	set new.idPengguna=varIdPengguna;
    set new.idProduk=varIdProduk;
end if;
end <>
delimiter ;

select*from pengguna;
select*from produk;
select*from produkfavorit;
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('tono','Headphone Sony');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Headphone Asus');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Headphone Sony');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Kemeja Denim');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Kemeja Denim');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Sepatu Nike Running');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('lauraz','Kemeja Denim');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('budiz','Kemeja Denim');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('liliaz','Kemeja Denim');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('budiz','Sepatu Nike Running');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('liliaz','Headphone Sony');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Laptop Asus ZenForce');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('lauraz','Headphone Sony');
INSERT INTO `shop`.`produkFavorit` (`idPengguna`, `idProduk`) VALUES ('ilhamz','Carolina Herera');

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
	signal sqlstate '44444'
	set message_text = 'Pengguna tidak diketahui, tidak dapat menambah data';
elseif(varIdProduk is null) then
	signal sqlstate '44444'
	set message_text = 'Produk tidak diketahui, tidak dapat menambah data';
elseif(cekKeranjang!=0) then
	signal sqlstate '44444'
	set message_text = 'Produk sudah dalam list keranjang, tidak dapat menambah data';
elseif(cekStok=0) then
	signal sqlstate '44444'
	set message_text = 'Stok kosong, tidak dapat menambah data';
elseif(new.jumlah>cekStok) then
	signal sqlstate '44444'
	set message_text = 'Stok tidak tersedia, tidak dapat menambah data';
else
	set new.idPengguna=varIdPengguna;
    set new.idProduk=varIdProduk;
end if;
end <>
delimiter ;

INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('tono','Headphone Sony',20);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Headphone Asus',30);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Carolina Herera',40);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Kemeja Denim',51);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Kemeja Denim',30);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Kemeja Denim',1);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Sepatu Nike Running',20);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('lauraz','Kemeja Denim',2);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('budiz','Headphone Sony',5);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('liliaz','Headphone Sony',20);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('budiz','Sepatu Nike Running',1);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('liliaz','Laptop Asus ZenForce',1);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('ilhamz','Laptop Asus ZenForce',2);
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`,`jumlah`) VALUES ('lauraz','Headphone Sony',3);
select*from keranjang;