using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Common;
using System.Data.Linq;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Printing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml.Linq;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.Kernel.Pdf.Canvas.Draw;
using iText.Kernel.Geom;
using iText.Kernel.Colors;
using iText.Layout.Borders;
using iText.Kernel.Font;
using iText.IO.Font;
using iText.IO.Font.Constants;
using iText.Layout.Properties;
using iText.IO.Image; // Thêm namespace cho ImageDataFactory
using OfficeOpenXml;
using QuanlyShopGiayDep.BLL;
using QuanlyShopGiayDep.DAL;
using QuanlyShopGiayDep.Forms;
using QuanlyShopGiayDep.Model;
using LicenseContext = OfficeOpenXml.LicenseContext;
using HorizontalAlignment = iText.Layout.Properties.HorizontalAlignment;

namespace QuanlyShopGiayDep
{
    public partial class FrmOrders : Form
    {
        public FrmOrders()
        {
            InitializeComponent();
        }

        int current_row = -1;
        private string Username = "";
        BLLStaff staffbll = new BLLStaff();

        public FrmOrders(string username)
        {
            InitializeComponent();
            Username = username;
        }

        private void CapQuyenExcel()
        {
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
        }

        BLLInvoice invoicebll = new BLLInvoice();

        private void LoadDataGridView()
        {
            DataTable data = new DataTable();
            data = invoicebll.LoadData();
            dgvOrders.DataSource = data;
        }

        public void LoadData()
        {
            LoadDataGridView();
            foreach (DataGridViewColumn column in dgvOrders.Columns)
            {
                if (column.HeaderText.ToLower() == "ngày lập") continue;
                cmbOrderType.Items.Add(column.HeaderText);
            }
            cmbOrderType.SelectedIndex = 0;
            CapQuyenExcel();
        }

        private void FrmOrders_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private void ExportExcel(DataGridView data, string name)
        {
            using (var excelPackage = new ExcelPackage())
            {
                var worksheet = excelPackage.Workbook.Worksheets.Add("Dữ liệu");
                for (int i = 0; i < data.ColumnCount; i++)
                {
                    worksheet.Cells[1, i + 1].Value = data.Columns[i].HeaderText;
                }
                for (int i = 0; i < data.RowCount; i++)
                {
                    for (int j = 0; j < data.ColumnCount; j++)
                    {
                        worksheet.Cells[i + 2, j + 1].Value = data.Rows[i].Cells[j].Value;
                    }
                }
                var saveFileDialog = new SaveFileDialog();
                saveFileDialog.Filter = "Excel files (*.xlsx)|*.xlsx";
                saveFileDialog.FileName = name + ".xlsx";

                if (saveFileDialog.ShowDialog() == DialogResult.OK)
                {
                    excelPackage.SaveAs(new FileStream(saveFileDialog.FileName, FileMode.Create));
                    MessageBox.Show("Xuất file Excel thành công!");
                }
            }
        }

        private void btnExportExcelOrders_Click(object sender, EventArgs e)
        {
            ExportExcel(dgvOrders, "ListOrders");
        }

        public void SearchByType(string type, string input)
        {
            dgvOrders.DataSource = invoicebll.SearchByType(type, input);
        }

        private void txtInputSearchOrder_TextChanged(object sender, EventArgs e)
        {
            string SearchInput = txtInputSearchOrder.Text;
            string tieuchi = cmbOrderType.SelectedItem.ToString();
            if (string.IsNullOrEmpty(SearchInput))
            {
                LoadDataGridView();
                return;
            }
            SearchByType(tieuchi, SearchInput);
        }

        private void btnDropOrder_Click(object sender, EventArgs e)
        {
            if (current_row == -1)
            {
                MessageBox.Show("Vui lòng chọn hóa đơn muốn xóa.", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            int id = int.Parse(dgvOrders.Rows[current_row].Cells[0].Value.ToString());
            if (MessageBox.Show("Bạn thật sự muốn xóa " + id.ToString(), "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) == DialogResult.Yes)
            {
                int row_effect = invoicebll.RemoveInvoice(id);
                if (row_effect > 0)
                {
                    MessageBox.Show("Xóa thành công " + id.ToString(), "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    LoadDataGridView();
                }
            }
        }

        private void dgvOrders_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            current_row = e.RowIndex;
        }

        private void btnAddOrder_Click(object sender, EventArgs e)
        {
            FrmAddOrder frmaddorder = new FrmAddOrder(Username);
            frmaddorder.ShowDialog();
            LoadDataGridView();
        }

        private DataTable GetDetailInvoie(int id)
        {
            DataTable dt = new DataTable();
            dt = invoicebll.GetDetailInvoie(id);
            return dt;
        }

        private DataTable GetInfoCustomerByIDInvoice(int id)
        {
            DataTable dt = new DataTable();
            dt = invoicebll.GetInfoCustomerByIDInvoice(id);
            return dt;
        }

        private void setFormat(ref Document document, string title, string value, PdfFont font)
        {
            Table table = new Table(2);
            table.SetWidth(UnitValue.CreatePercentValue(100));

            Cell titleCell = new Cell().Add(new Paragraph(title).SetFont(font));
            titleCell.SetBorder(Border.NO_BORDER);
            titleCell.SetTextAlignment(TextAlignment.LEFT);
            table.AddCell(titleCell);

            Cell valueCell = new Cell().Add(new Paragraph(value).SetFont(font));
            valueCell.SetBorder(Border.NO_BORDER);
            valueCell.SetTextAlignment(TextAlignment.RIGHT); // Căn phải cho giá trị
            table.AddCell(valueCell);

            document.Add(table);
        }

        private string GetNameStaffByIDInvoice(int id)
        {
            return staffbll.GetNameStaffByIDInvoice(id);
        }

        private DataTable GetTimeByIDInvoice(int id)
        {
            return invoicebll.GetTimeByIDInvoice(id);
        }

        private void ExportToPDF(int id)
        {
            DataTable data = GetDetailInvoie(id);
            DataTable Time = GetTimeByIDInvoice(id);
            string filePath = "C:\\Study\\Lean_University\\Nam-3\\HK2\\DOT-Net\\BTL\\QuanlyShopGiayDep\\output.pdf";

            PdfWriter writer = new PdfWriter(filePath);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf, PageSize.A5);
            document.SetMargins(5, 5, 5, 5);

            // Thêm hình ảnh logo
            string imagePath = "C:\\Study\\Lean_University\\Nam-3\\HK2\\DOT-Net\\BTL\\QuanlyShopGiayDep\\logoInvoiceExport.png";
            iText.Layout.Element.Image img = new iText.Layout.Element.Image(iText.IO.Image.ImageDataFactory.Create(imagePath));
            img.ScaleToFit(150, 150);
            img.SetHorizontalAlignment(HorizontalAlignment.CENTER);
            document.Add(img);

            // Tạo font
            PdfFont textFont = PdfFontFactory.CreateFont("C:\\Windows\\Fonts\\Arial.ttf", PdfEncodings.IDENTITY_H);
            PdfFont boldFont = PdfFontFactory.CreateFont("C:\\Windows\\Fonts\\Arialbd.ttf", PdfEncodings.IDENTITY_H);

            // Tiêu đề hóa đơn
            Paragraph title = new Paragraph("HÓA ĐƠN THANH TOÁN")
                .SetFont(boldFont)
                .SetFontSize(12)
                .SetTextAlignment(TextAlignment.CENTER);
            document.Add(title);

            // Mã hóa đơn
            Paragraph mahd = new Paragraph("Mã HĐ: " + id.ToString())
                .SetFont(boldFont)
                .SetFontSize(12)
                .SetTextAlignment(TextAlignment.CENTER)
                .SetMarginBottom(20);
            document.Add(mahd);

            // Thông tin nhân viên
            Paragraph nhanvien = new Paragraph()
                .Add(new Text("Thu Ngân: ").SetFont(boldFont))
                .Add(new Text(GetNameStaffByIDInvoice(id)).SetFont(textFont))
                .SetFontSize(12)
                .SetTextAlignment(TextAlignment.LEFT)
                .SetMarginBottom(10);
            document.Add(nhanvien);

            // Ngày lập
            Paragraph ngaylap = new Paragraph()
                .Add(new Text("Ngày lập: ").SetFont(boldFont))
                .Add(new Text(Time.Rows[0]["Ngày"].ToString() + "/" + Time.Rows[0]["Tháng"].ToString() + "/" + Time.Rows[0]["Năm"].ToString()).SetFont(textFont))
                .SetFontSize(12)
                .SetTextAlignment(TextAlignment.LEFT)
                .SetMarginBottom(10);
            document.Add(ngaylap);

            // Giờ lập
            Paragraph giolap = new Paragraph()
                .Add(new Text("Giờ: ").SetFont(boldFont))
                .Add(new Text(Time.Rows[0]["Giờ"].ToString()).SetFont(textFont))
                .SetFontSize(12)
                .SetTextAlignment(TextAlignment.LEFT)
                .SetMarginBottom(20);
            document.Add(giolap);

            // Tạo bảng chi tiết hóa đơn
            Table pdfTable = new Table(data.Columns.Count + 1);
            pdfTable.SetWidth(UnitValue.CreatePercentValue(100));

            // Header bảng
            Cell ttCellHeader = new Cell().Add(new Paragraph("TT").SetFont(boldFont));
            ttCellHeader.SetTextAlignment(TextAlignment.CENTER);
            pdfTable.AddCell(ttCellHeader);

            foreach (DataColumn column in data.Columns)
            {
                Cell cell = new Cell().Add(new Paragraph(column.ColumnName).SetFont(boldFont));
                cell.SetTextAlignment(TextAlignment.CENTER);
                pdfTable.AddCell(cell);
            }

            // Dữ liệu bảng
            int rowNumber = 1;
            int sumPrice = 0;
            foreach (DataRow row in data.Rows)
            {
                Cell ttCell = new Cell().Add(new Paragraph(rowNumber.ToString()).SetFont(textFont));
                ttCell.SetTextAlignment(TextAlignment.CENTER);
                pdfTable.AddCell(ttCell);

                sumPrice += int.Parse(row["Thành Tiền"].ToString());
                foreach (var cellValue in row.ItemArray)
                {
                    Cell cell = new Cell().Add(new Paragraph(cellValue.ToString()).SetFont(textFont));
                    cell.SetTextAlignment(TextAlignment.CENTER);
                    pdfTable.AddCell(cell);
                }
                rowNumber++;
            }
            document.Add(pdfTable);

            // Thêm khoảng cách
            document.Add(new Paragraph("\n"));

            // Tổng tiền, tiền khách đưa, tiền thừa
            string sumPriceString = sumPrice.ToString("N0", new CultureInfo("vi-VN"));
            setFormat(ref document, "Tiền Thanh Toán: ", sumPriceString, boldFont);
            setFormat(ref document, "Tiền Khách Đưa: ", sumPriceString, boldFont);
            setFormat(ref document, "Tiền Thừa: ", "0", boldFont);

            // Thêm khoảng cách
            document.Add(new Paragraph("\n"));

            // Thêm đường kẻ phân cách
            ILineDrawer line = new SolidLine(1f);
            line.SetColor(ColorConstants.BLACK);
            LineSeparator lineSeparator = new LineSeparator(line);
            document.Add(lineSeparator);

            // Lưu ý
            Paragraph luuY = new Paragraph("Lưu ý: Quy đổi 1đ = 100k")
                .SetFont(boldFont)
                .SetFontSize(12)
                .SetTextAlignment(TextAlignment.LEFT);
            document.Add(luuY);

            // Thêm khoảng cách và đường kẻ
            document.Add(new Paragraph("\n"));
            ILineDrawer line2 = new SolidLine(1f);
            line2.SetColor(ColorConstants.BLACK);
            LineSeparator lineSeparator2 = new LineSeparator(line2);
            document.Add(lineSeparator2);

            // Thông tin khách hàng
            document.Add(new Paragraph("\n"));
            DataTable infocustomer = GetInfoCustomerByIDInvoice(id);
            if (infocustomer.Rows.Count > 0)
            {
                setFormat(ref document, "+ Tên hội viên: ", infocustomer.Rows[0]["Name"].ToString(), textFont);
                setFormat(ref document, "+ Điểm tích lũy: ", infocustomer.Rows[0]["Score"].ToString(), textFont);
            }

            // Đóng tài liệu
            document.Close();

            // Mở file PDF
            Process.Start(new ProcessStartInfo(filePath) { UseShellExecute = true });
        }

        private void btnViewDetail_Click(object sender, EventArgs e)
        {
            if (current_row == -1)
            {
                MessageBox.Show("Vui lòng chọn hóa đơn muốn xem.", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            int IDInvoice = int.Parse(dgvOrders.Rows[current_row].Cells[0].Value.ToString());
            ExportToPDF(IDInvoice);
        }
    }
}