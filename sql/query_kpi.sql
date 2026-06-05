-- =====================================================
-- QUERY KEY PERFORMANCE INDICATORS (KPI)
-- DATA WAREHOUSE PENJUALAN OLIST
-- =====================================================

USE dw_penjualan_olist;


-- ---------------------------------------------------------------------
-- KPI 1: Tren Penjualan Bulanan dan Volume Transaksi
-- Tujuan: Mengetahui total penjualan, jumlah pesanan, dan item per bulan.
-- ---------------------------------------------------------------------
SELECT
    dw.tahun,
    dw.bulan,
    ROUND(SUM(fp.harga_barang), 2) AS total_penjualan,
    COUNT(fp.id_fakta) AS jumlah_item_terjual,
    COUNT(DISTINCT fp.id_pesanan) AS jumlah_pesanan
FROM fact_penjualan fp
JOIN dim_waktu dw ON fp.id_waktu = dw.id_waktu
GROUP BY 
    dw.tahun, 
    dw.bulan
ORDER BY 
    dw.tahun ASC, 
    dw.bulan ASC;


-- ---------------------------------------------------------------------
-- KPI 2: Lima Kategori Produk dengan Penjualan Tertinggi
-- Tujuan: Mengetahui top 5 kategori berdasarkan nilai total penjualan.
-- ---------------------------------------------------------------------
SELECT
    dp.kategori_produk,
    COUNT(fp.id_fakta) AS jumlah_item_terjual,
    COUNT(DISTINCT fp.id_pesanan) AS jumlah_pesanan,
    ROUND(SUM(fp.harga_barang), 2) AS total_penjualan,
    ROUND(AVG(fp.harga_barang), 2) AS rata_rata_harga_item
FROM fact_penjualan fp
JOIN dim_produk dp ON fp.id_produk = dp.id_produk
GROUP BY 
    dp.kategori_produk
ORDER BY 
    total_penjualan DESC
LIMIT 5;


-- ---------------------------------------------------------------------
-- KPI 3: Kinerja Penjual Berdasarkan Total Penjualan
-- Tujuan: Mengidentifikasi top 10 penjual paling berkontribusi.
-- ---------------------------------------------------------------------
SELECT
    dp.id_penjual,
    dp.kota_penjual,
    dp.provinsi_penjual,
    SUM(fp.harga_barang) AS total_penjualan
FROM fact_penjualan fp
JOIN dim_penjual dp ON fp.id_penjual = dp.id_penjual
GROUP BY
    dp.id_penjual,
    dp.kota_penjual,
    dp.provinsi_penjual
ORDER BY 
    total_penjualan DESC
LIMIT 10;


-- ---------------------------------------------------------------------
-- KPI 4: Total Ongkos Kirim per Kuartal
-- Tujuan: Menghitung rasio/persentase ongkir terhadap total penjualan.
-- ---------------------------------------------------------------------
SELECT
    dw.tahun,
    dw.kuartal,
    SUM(fp.ongkos_kirim) AS total_ongkos_kirim,
    SUM(fp.harga_barang) AS total_penjualan,
    ROUND((SUM(fp.ongkos_kirim) / SUM(fp.harga_barang)) * 100, 2) AS rasio_ongkir_persen
FROM fact_penjualan fp
JOIN dim_waktu dw ON fp.id_waktu = dw.id_waktu
GROUP BY 
    dw.tahun, 
    dw.kuartal
ORDER BY 
    dw.tahun ASC, 
    dw.kuartal ASC;


-- ---------------------------------------------------------------------
-- KPI 5: Total Penjualan Berdasarkan Provinsi Pelanggan
-- Tujuan: Mengetahui persebaran pasar pembeli Olist berdasarkan wilayah.
-- ---------------------------------------------------------------------
SELECT
    dc.provinsi_pelanggan,
    COUNT(DISTINCT fp.id_pesanan) AS jumlah_pesanan,
    SUM(fp.harga_barang) AS total_penjualan,
    COUNT(DISTINCT dc.id_pelanggan) AS jumlah_pelanggan
FROM fact_penjualan fp
JOIN dim_pelanggan dc ON fp.id_pelanggan = dc.id_pelanggan
GROUP BY 
    dc.provinsi_pelanggan
ORDER BY 
    total_penjualan DESC;
