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
  `username` VARCHAR(255) NOT NULL,
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
  `alamat` VARCHAR(255) NOT NULL,
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