create or replace view daftarPromoTerhubung as select pe.namaLengkap as `Nama Pengguna`,pe.level as `Level Pengguna`,
pr.nama as `Nama Promo`, pr.levelPengguna `Level Minimal Promo`, pr.minTransaksi as `Minimal Transaksi`
from promoTerhubung pt join pengguna pe join promo pr where pe.id = pt.idPengguna and pr.id = pt.idPromo;
select * from daftarPromoTerhubung;

create or replace view top3ProdukFavorit as select produk.nama as `Nama Produk`,pelapak.nama as `Nama Pelapak`,count(*)
from produk join pelapak join produkFavorit where produk.idPelapak = pelapak.id and produkFavorit.idProduk = produk.id 
group by produk.nama order by count(idProduk) desc limit 3;
select*from top3ProdukFavorit;