create or replace view daftarPromoTerhubung as select pe.namaLengkap as `Nama Pengguna`,pe.level as `Level Pengguna`,
pr.nama as `Nama Promo`, pr.levelPengguna `Level Minimal Promo`, pr.minTransaksi as `Minimal Transaksi`
from promoTerhubung pt join pengguna pe join promo pr where pe.id = pt.idPengguna and pr.id = pt.idPromo;
select * from daftarPromoTerhubung;

create or replace view top3ProdukFavorit as select produk.nama as `Nama Produk`,pelapak.nama as `Nama Pelapak`,count(*)
from produk join pelapak join produkFavorit where produk.idPelapak = pelapak.id and produkFavorit.idProduk = produk.id 
group by produk.nama order by count(idProduk) desc limit 3;
select*from top3ProdukFavorit;

create or replace view lihatSemuaPesanan as select pesanan.id as `ID`,pengguna.namaLengkap as `Nama Pengguna`,
sum((detailPesanan.jumlah*produk.harga)-((detailPesanan.jumlah*produk.harga)*(promo.diskon/100))) as `Total Harga`, pesanan.tanggal as `Tanggal`
from detailPesanan left join pesanan on detailPesanan.idPesanan=pesanan.id join produk on detailPesanan.idProduk=produk.id
join pengguna on pesanan.idPengguna=pengguna.id group by pesanan.id order by pesanan.tanggal asc;
select*from lihatSemuaPesananProduk;

create or replace view lihatSemuaPesananProduk as select produk.nama as `Nama Produk`,pengguna.namaLengkap as `Nama Pengguna`,
detailPesanan.jumlah as `Jumlah`, pesanan.tanggal as `Tanggal`
from detailPesanan left join pesanan on detailPesanan.idPesanan=pesanan.id join produk on detailPesanan.idProduk=produk.id
join pengguna on pesanan.idPengguna=pengguna.id order by pesanan.tanggal asc;
select*from lihatSemuaPesananProduk;

select*from produk;
select*from pesanan;
select*from detailpesanan;

