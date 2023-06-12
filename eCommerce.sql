create database shop;
use shop;

call reset();
delimiter <>
create or replace procedure reset()
begin

drop table if exists promoterhubung;
drop table if exists keranjang;
drop table if exists detailpesanan;
drop table if exists pesanan;
drop table if exists dompetterhubung;
drop table if exists promo;
drop table if exists barangfavorit;
drop table if exists produk;
drop table if exists kategori;
drop table if exists alamat;
drop table if exists pelapak;
drop table if exists pengguna;
drop table if exists dompetdigital;

CREATE TABLE IF NOT EXISTS `shop`.`pengguna` (
  `id` CHAR(36) NOT NULL,
  `namaLengkap` VARCHAR(255) NOT NULL,
  `noTelp` VARCHAR(20),
  `email` VARCHAR(255),
  `password` VARCHAR(255) NOT NULL,
  `pin` CHAR(4),
  `level` INT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`kategori` (
  `id` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`promo` (
  `id` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `deskripsi` VARCHAR(255) NOT NULL,
  `minTransaksi` DECIMAL(10,2) NOT NULL,
  `levelPengguna` INT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`dompetDigital` (
  `id` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`alamat` (
  `id` CHAR(36) NOT NULL,
  `idPengguna` CHAR(36) NOT NULL,
  `alamatLengkap` VARCHAR(255) NOT NULL,
  `alamatSebagai` ENUM('rumah','apartemen','kantor','lainnya'),
  `namaPenerima` VARCHAR(255) NOT NULL,
  `noTelp` VARCHAR(20) NOT NULL,
  `kecamatan` VARCHAR(255) NOT NULL,
  `kota` VARCHAR(255) NOT NULL,
  `provinsi` VARCHAR(255) NOT NULL,
  `kodePos` INT(5) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPengguna`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
    PRIMARY KEY(`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`dompetTerhubung` (
  `idPengguna` CHAR(36) NOT NULL,
  `idDompet` CHAR(36) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPenggunaDompet`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idDompetTerhubung`
    FOREIGN KEY (`idDompet`)
    REFERENCES `shop`.`dompetDigital` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`promoTerhubung` (
  `idPengguna` CHAR(36) NOT NULL,
  `idPromo` CHAR(36) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPenggunaPromo`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idPromoTerhubung`
    FOREIGN KEY (`idPromo`)
    REFERENCES `shop`.`promo` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`pelapak` (
  `id` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `lokasi` VARCHAR(20) NOT NULL,
  `feedbackPositif` VARCHAR(255) NOT NULL,
  `waktuProsesTercepat` INT NOT NULL,
  `waktuProsesTerlama` INT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`produk` (
  `id` CHAR(36) NOT NULL,
  `idKategori` CHAR(36) NOT NULL,
  `idPelapak` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `rating` DOUBLE NOT NULL,
  `ulasan` INT NOT NULL,
  `stok` INT NOT NULL,
  `terjual` INT NOT NULL,
  `kondisi` ENUM('baru', 'lama', 'bekas'),
  `berat` INT NOT NULL,
  `asal` ENUM('lokal','impor'),
  `deskripsi` TEXT NOT NULL,
  `harga` DECIMAL(10,2) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_idKategoriProduk`
    FOREIGN KEY (`idKategori`)
    REFERENCES `shop`.`kategori` (`id`),
  CONSTRAINT `fk_idPelapakProduk`
    FOREIGN KEY (`idPelapak`)
    REFERENCES `shop`.`pelapak` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`barangFavorit` (
  `idPengguna` CHAR(36) NOT NULL,
  `idProduk` CHAR(36) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPenggunaFavorit`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idProdukFavorit`
    FOREIGN KEY (`idProduk`)
    REFERENCES `shop`.`produk` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`keranjang` (
  `idPengguna` CHAR(36) NOT NULL,
  `idProduk` CHAR(36) NOT NULL,
  `jumlah` INT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPenggunaKeranjang`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idProdukKeranjang`
    FOREIGN KEY (`idProduk`)
    REFERENCES `shop`.`produk` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`pesanan` (
  `id` CHAR(36) NOT NULL,
  `idPengguna` CHAR(36) NOT NULL,
  `idPelapak` CHAR(36) NOT NULL,
  `idPromo` CHAR(36) NOT NULL,
  `idAlamat` CHAR(36) NOT NULL,
  `idDompet` CHAR(36) NOT NULL,
  `tanggal` DATE NOT NULL,
  `catatan` VARCHAR(255),
  `status` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_idPenggunaPesanan`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idPelapakPesanan`
    FOREIGN KEY (`idPelapak`)
    REFERENCES `shop`.`pelapak` (`id`),
  CONSTRAINT `fk_idPromoPesanan`
    FOREIGN KEY (`idPromo`)
    REFERENCES `shop`.`promo` (`id`),
    CONSTRAINT `fk_idAlamatPesanan`
    FOREIGN KEY (`idAlamat`)
    REFERENCES `shop`.`alamat` (`id`),
  CONSTRAINT `fk_idDompetPesanan`
    FOREIGN KEY (`idDompet`)
    REFERENCES `shop`.`dompetDigital` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`detailPesanan` (
  `idPesanan` CHAR(36) NOT NULL,
  `idProduk` CHAR(36) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPesananDetailPesanan`
    FOREIGN KEY (`idPesanan`)
    REFERENCES `shop`.`pesanan` (`id`),
  CONSTRAINT `fk_idProdukPesanan`
    FOREIGN KEY (`idProduk`)
    REFERENCES `shop`.`produk` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

end <>
delimiter ;


-- Table alamat
INSERT INTO `shop`.`alamat` (`id`, `idPengguna`, `alamatLengkap`, `alamatSebagai`, `namaPenerima`, `noTelp`, `kecamatan`, `kota`, `provinsi`, `kodePos`)
-- Dummy 1
SELECT
uuid(),(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Ilham') AS idPengguna,
'Jl. Rambutan No. 123', 'rumah', 'Ilham', '08129022310', 'Kec. Rambutan', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32511
UNION ALL
-- Dummy 2
SELECT
uuid(),(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Cita') AS idPengguna,
'Jl. Mangga No. 456', 'kantor', 'Cita', '087638172311', 'Kec. Mangga', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32512
UNION ALL
-- Dummy 3
SELECT
uuid(),(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Laura') AS idPengguna,
'Jl. Apel No. 789', 'rumah', 'Laura', '085367818912', 'Kec. Apel', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32513
UNION ALL
-- Dummy 4
SELECT
uuid(),(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Windah') AS idPengguna,
'Jl. Jeruk No. 101', 'rumah', 'Windah', '085378908716', 'Kec. Jeruk', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32514
UNION ALL
-- Dummy 5
SELECT
uuid(),(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Basudara') AS idPengguna,
'Jl. Manggis No. 202', 'rumah', 'Basudara', '085379809112', 'Kec. Manggis', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32515;
  

-- Table dompetTerhubung
INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`)
-- Dummy 1
SELECT 
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Ilham") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "OVO")AS idDompet
UNION ALL 
-- Dummy 2
SELECT
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Cita") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "GoPay")AS idDompet
-- Dummy 3
UNION ALL
SELECT 
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Laura") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "BCA")AS idDompet 
UNION ALL
-- Dummy 4
SELECT 
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Windah") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "OVO")AS idDompet
-- Dummy 5
UNION ALL
SELECT 
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Basudara") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "OVO")AS idDompet ;


-- TABLE PROMOTERHUBUNG
-- Dummy 1
INSERT INTO `shop`.`promoTerhubung` (`idPengguna`, `idPromo`)
 SELECT
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Ilham") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo Lebaran" ) AS idPromo
-- Dummy 2
UNION ALL
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Cita") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo 6.6" ) AS idPromo
-- Dummy 3
UNION ALL
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Laura") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo Natal" ) AS idPromo
-- Dummy 4
UNION ALL
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Windah") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo Potongan" ) AS idPromo
-- Dummy 5
UNION ALL
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Basudara") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo Tahun Baru" ) AS idPromo;


-- Table pelapak
INSERT INTO `shop`.`pelapak` (`id`, `nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) 
-- Dummy 1
VALUES 
(UUID(), 'Asus Official', 'Jakarta', 'positif', 2, 5),
-- Dummy 2
(UUID(), 'Zara', 'Bandung', 'positif', 1, 3), 
 -- Dummy 3
(UUID(), 'Indonesia Merk', 'Jakarta', 'positif', 3, 5),
-- Dummy 4
(UUID(), 'Xyz Shop', 'Bandung', 'negatif', 20, 24), 
 -- Dummy 5
(UUID(), 'H&M', 'Jakarta', 'positif', 1, 2),
 -- Dummy 6
(UUID(), 'Gucci', 'Kalimantan', 'positif', 1, 3),
 -- Dummy 7
(UUID(), 'Sonny Official', 'Jakarta', 'positif', 2, 4),
-- Dummy 8
(UUID(), 'Samsung Official', 'Jakarta', 'negatif', 1, 3),
 -- Dummy 9
(UUID(), 'Nike', 'Jakarta', 'negatif', 1, 6);


-- Table produk
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
-- Dummy 1
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Elektronik" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Asus Official"), 
'Laptop Asus ZenForce', 4.5, 10, 20, 5, 'baru', 2, 'lokal', 'Laptop Asus Zenforce Ram 12GB', 5000000);
-- Dummy 2
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Fashion" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Zara"), 
'Kemeja Denim', 4.2, 8, 50, 15, 'baru', 0.5, 'lokal', 'Kemeja Denim Pria Ukuran M', 350000);
-- Dummy 3
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Fashion" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "H&M"), 
'Celana Jeans Slim Fit', 4.0, 6, 40, 12, 'baru', 0.7, 'lokal', 'Celana Jeans Slim Fit Warna Biru', 250000);
-- Dummy 4
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Fashion" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Nike"), 
'Sepatu Nike Running', 4.5, 18, 45, 10, 'baru', 0.6, 'impor', 'Sepatu Nike Running Pria', 800000);
-- Dummy 5
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Elektronik" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Sonny Official"), 
'Headphone Sony', 4.6, 12, 25, 8, 'baru', 0.4, 'impor', 'Headphone Sony Noise-Canceling', 1200000);


-- Table barangFavorit
INSERT INTO `shop`.`barangFavorit` (`idPengguna`, `idProduk`)
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Ilham"),
 (SELECT id FROM shop.produk WHERE nama = "Headphone Sony" );
 

-- Table keranjang
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 1
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Ilham" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Laptop Asus ZenForce") AS idProduk, 1;
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 2
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Cita" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Kemeja Denim") AS idProduk, 3;
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 3
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Laura" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Celana Jeans Slim Fit") AS idProduk, 2;
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 4
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Windah" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Sepatu Nike Running") AS idProduk, 4;
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 5
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Basudara" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Headphone Sony") AS idProduk, 1;


-- Table pesanan
--  Dummy 1
INSERT INTO `shop`.`pesanan` (`id`, `idPengguna`, `idPelapak`, `idPromo`, `idAlamat`, `idDompet`, `tanggal`, `catatan`, `status`)
VALUES (uuid_short(), 
(SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Ilham"),
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Asus Official"), 
(SELECT `id` FROM `shop`.`promo` WHERE nama = "Promo Lebaran"),
(SELECT `id` FROM `shop`.`alamat` WHERE kodePos='32511'),
 (SELECT `id` FROM `shop`.`dompetDigital` WHERE nama = "OVO" ), 
 '2023-06-06', ' ', 'proses');
 
--  Dummy 2
INSERT INTO `shop`.`pesanan` (`id`, `idPengguna`, `idPelapak`, `idPromo`, `idAlamat`, `idDompet`, `tanggal`, `catatan`, `status`)
VALUES (uuid_short(),
(SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Cita"), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Zara"), 
(SELECT `id` FROM `shop`.`promo` WHERE nama = "Promo 6.6"),
(SELECT `id` FROM `shop`.`alamat` WHERE kodePos='32511'),
 (SELECT `id` FROM `shop`.`dompetDigital` WHERE nama = "OVO" ), 
 '2023-06-06', ' ', 'proses');
 
 -- Table detailpesanan
 --  Dummy 1
INSERT INTO `shop`.`detailpesanan` (`idPesanan`, `idProduk`) values
((SELECT `id` FROM `shop`.`pesanan`  WHERE idpengguna = (SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Cita")),
(SELECT `id` FROM `shop`.`produk`  WHERE nama = "Laptop Asus ZenForce"));

 --  Dummy 1

INSERT INTO `shop`.`detailpesanan` (`idPesanan`, `idProduk`) values
((SELECT `id` FROM `shop`.`pesanan`  WHERE idpengguna = (SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Ilham")),
(SELECT `id` FROM `shop`.`produk`  WHERE nama = "Kemeja Denim"));


delimiter <>
create or replace trigger register 
before insert on pengguna for each row
begin
declare cekNoTelp int;
declare cekEmail int;
set cekNoTelp=(select noTelp from pengguna where noTelp= new.noTelp);
set cekEmail=(select email from pengguna where email=new.Email);
if (cekNoTelp is null and new.noTelp is not null) then
	if(char_length(new.password)<8) then
		signal sqlstate '44444'
		set message_text = 'Password minimal 8 digit!!';
	else
		set new.id = uuid();
		set new.password=password(new.password);
        set new.level=1;
	end if;
elseif(cekEmail is null and new.email is not null) then
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
	set message_text = 'Nomor telepon atau email sudah terdaftar';
end if;
end <>
delimiter ;
select*from pengguna;
INSERT INTO `shop`.`pengguna` (`namaLengkap`, `noTelp`, `email`, `password`, `pin`) VALUES 
('Ilham', '08129022310', 'ilham@gmail.com', 'ilham7580', '7580');

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `email`, `password`) VALUES 
('Ilham', 'ilham@gmail.com', 'ilham7580');-- email sama

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `noTelp`, `password`) VALUES 
('Ilham', '08129022310', 'ilham7580');-- no telepon sama

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `noTelp`, `password`) VALUES 
('Laura', '085367818912', 'laura12');-- password <8 digit

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `noTelp`,`email`, `password`) VALUES 
('Laura', '085367818912', 'Laura22@gmail.com','laura123');

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `noTelp`,`email`, `password`, `pin`) VALUES 
('Budi', '0846635353553', 'budi343@gmail.com','budi6565','6565');

select*from pengguna;
call reset();
delimiter <>
create or replace procedure validasiLoginViaNoTelp(varNoTelp varchar(255),varPassword varchar(255))
begin
declare cekNoTelp int;
declare cekPassword int;
set cekNoTelp=(select noTelp from pengguna where noTelp= varNoTelp);
set cekPassword=(select password from pengguna where noTelp=varNoTelp and password=password(varPassword));
if(cekNoTelp is null) then
	signal sqlstate '44444'
	set message_text = 'Nomor telepon yang diinput belum terdaftar';-- lewat dari if ini berarti no telp pasti terdaftar
else 
	if(cekPassword is null) then
		signal sqlstate '44444'
		set message_text = 'Password yang diinput salah';
	else
		select 'Login Berhasil' as Notifikasi,now() as Waktu;
	end if;
end if;
end <>
delimiter ;

call validasiLoginViaNoTelp('99999999999','ilham7580');
call validasiLoginViaNoTelp('08129022310','hhhhhhhhh');
call validasiLoginViaNoTelp('08129022310','ilham7580');

delimiter <>
create or replace procedure validasiLoginViaEmail(varEmail varchar(255),varPassword varchar(255))
begin
declare cekEmail int;
declare cekPassword int;
set cekEmail=(select email from pengguna where email=varEmail);
set cekPassword=(select password from pengguna where email=varEmail and password=password(varPassword));
if(cekEmail is null) then
	signal sqlstate '44444'
	set message_text = 'Email yang diinput belum terdaftar';-- lewat dari if ini berarti email pasti terdaftar
else 
	if(cekPassword is null) then
		signal sqlstate '44444'
		set message_text = 'Password yang diinput salah';
	else
		select 'Login Berhasil' as Notifikasi,now() as Waktu;
	end if;
end if;
end <>
delimiter ;

call validasiLoginViaEmail('hhhhh@gmail.com','ilham7580');
call validasiLoginViaEmail('ilham@gmail.com','hhhhhhhhh');
call validasiLoginViaEmail('ilham@gmail.com','ilham7580');

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
	set message_text = 'Pelapak sudah ada, tidak bisa menambah data';
end if;
set new.id = uuid();
end <>
delimiter ;
select*from pelapak;
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Asus Official', 'Jakarta', 'positif', 2, 5);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Zara', 'Bandung', 'positif', 1, 3);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Asus Official', 'Jakarta', 'positif', 4, 6);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Indonesia Merk', 'Jakarta', 'positif', 3, 5);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Xyz Shop', 'Bandung', 'positif', 20, 24);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('H&M', 'Jakarta', 'positif', 1, 2);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Gucci', 'Kalimantan', 'positif', 1, 3);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Sonny Official', 'Jakarta', 'positif', 2, 4);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Samsung Official', 'Jakarta', 'negatif', 1, 3);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Samsung Official', 'Jakarta', 'negatif', 1, 6);
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
create or replace procedure sebarPromo()
begin
declare i int default 0;
declare j int default 0;
declare jumlahPengguna int;
declare jumlahPromo int;
declare cekLevel int;
declare idPengguna char(36);
declare idPromo char(36);
set jumlahPengguna=(select count(id) from pengguna);
set jumlahPromo=(select count(id) from promo);
if (jumlahPengguna=0) then
	signal sqlstate '44444'
	set message_text = 'Tidak ada pelanggan';
else
	while (i<jumlahPengguna) do -- 1 2 3
		if(i=0) then
			set cekLevel=(select level from pengguna limit 0,1);
            set idPengguna=(select id from pengguna limit 0,1);
		else 
			set cekLevel=(select level from pengguna limit i,i);
            set idPengguna=(select id from pengguna limit i,1);
		end if;
        set j=0;
        while(j<jumlahPromo) do
			if(j=0) then
				if(cekLevel>=(select levelPengguna from promo limit 0,1)) then
                    set idPromo=(select id from promo limit 0,1);
					insert into promoTerhubung (idPengguna,idPromo) values (idPengguna,idPromo);
                end if;
			else
				if(cekLevel>=(select levelPengguna from promo limit i,1)) then
					set idPromo=(select id from promo limit i,1);
					insert into promoTerhubung (idPengguna,idPromo) values (idPengguna,idPromo);
                end if;
			select (select namaLengkap from pengguna where id=idPengguna),(select nama from promo where id=idPromo);
            end if;
		set j=j+1;
		end while;
	set i=i+1;
    end while;
end if;
end <>
delimiter ;
call sebarPromo();
select*from promoTerhubung;
select id from promo limit 0,1;
insert into promoTerhubung values ('253cd964-090b-11ee-be34-00155d02be68',(select id from promo limit 0,1));
select*from pengguna;
select namaLengkap from pengguna where rowid=1;

select count(id) from pengguna;
use shop;

call reset();

create or replace view daftarPromoTerhubung as select pe.namaLengkap as `Nama Pengguna`,pr.nama as `Nama Promo`, 
pr.minTransaksi as `Minimal Transaksi`,pe.level as `Level Pengguna`,pr.levelPengguna `Level Minimal Promo`
from promoTerhubung pt join pengguna pe join promo pr 
where pe.id = pt.idPengguna and pr.id = pt.idPromo;
select * from daftarPromoTerhubung;

select*from promo;
select*from pengguna;
select*from pengguna where password="ilham7580";
call reset();

select *from pengguna;
select*from pengguna limit 2,1;
select*from promo limit 5,1;
select * from pengguna order by noTelp asc limit 1;
