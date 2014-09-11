require 'prawn'
require 'prawn/table'

# This module should be mixed to Invoice class.
#
module Invoice2PDF
  def c
    APP_CONFIG[:invoice]
  end

  def generate_pdf(filename = Time.now.to_i)
    Prawn::Document.generate(filename) do |pdf|
      pdf.text user.name, size: 24
      pdf.text user.duty, leading: 15
      upper_right_table(pdf)
      pdf.bounding_box([0, pdf.cursor], width: 300, height: 100) do
        pdf.text full_address
      end
      pdf.move_down 20
      pdf.text bank_info
      pdf.move_down 20
      bill_to(pdf)
      pdf.move_down 20
      pay_table(pdf)
      pdf.move_down 20
      bottom_tables pdf
      pdf.move_down 20
      contacts pdf
    end
  end

  def full_address
    user.address    + "\n" +
      user.city     + ', ' +
      user.country  + ', ' +
      user.zip.to_s + "\n" +
      user.phone
  end

  def bank_info
    'NAME: '              +
    user.name_for_bank_account + "\n" +
    'ACCOUNT #: '         +
    user.bank_account_number   + "\n" +
    'SWIFT: '             +
    user.bank_swift            + "\n" +
    'BANK_NAME: '         +
    user.bank_name
  end

  def upper_right_table(pdf)
    text = [['Date', created_at.to_date.to_s],
            ['INVOICE #', invoice_number],
            ['CUSTOMER ID', c[:customer_id]],
            ['Due Date', created_at.to_date + 20.days]
           ]
    pdf.bounding_box([300, 720], width: 200, height: 200) do
      pdf.text 'Invoice', size: 24
      pdf.table text
    end
    pdf.move_up 150
  end

  def bill_to(pdf)
    pdf.text 'BILL TO', style: :bold, leading: 5
    pdf.text bill_to_string
    pdf.move_down 10
    pdf.text c[:bill_to][:id]
  end

  def bill_to_string
    c[:bill_to].values_at(:company, :street_building, :city_index).join("\n")
  end

  def pay_table(pdf)
    pdf.table(pay_table_description, header: true) do |t|
      t.row(0).font_style = :bold
      t.width = pdf.bounds.width
      t.column(1).width = 0.1 * pdf.bounds.width
      t.column(2).width = 0.15 * pdf.bounds.width
    end
  end

  def pay_table_description
    [%w(DESCRIPTION TAXED AMOUNT), [invoice_description, '', total_amount]]
  end

  def bottom_tables(pdf)
    pay_table_end = pdf.cursor
    other_comments pdf
    pdf.bounding_box([300, pay_table_end], width: 200, height: 200) do
      total_due pdf
    end
    pdf.move_up 80
  end

  def other_comments(pdf)
    header = ['OTHER COMMENTS']
    due = ['1. Total payment due in 20 days']
    text = ([['']] * 6).unshift header, due
    pdf.table(text, header: true) do |t|
      t.row(0).font_style = :bold
      t.rows(1..6).borders = [:left, :right]
      t.row(7).borders = [:left, :right, :bottom]
      t.width = pdf.bounds.width * 0.5
    end
  end

  def total_due(pdf)
    text = [
      ['Subtotal',  '$', total_amount],
      ['Taxable',   '$', '-'],
      ['Tax Rate',  '$', '0.000%'],
      ['Tax due',   '$', '-'],
      ['TOTAL Due', '$', total_amount]]
    pdf.table(text, header: false) do |t|
      t.row(4).font_style = :bold
      t.width = pdf.bounds.width
      t.rows(0..4).borders = []
    end
  end

  def contacts(pdf)
    pdf.move_down 30
   pdf.text 'If you have any questions about this invoice, please contact', align: :center
   pdf.text c[:contacts], align: :center
   pdf.move_down 15
   pdf.text 'Thank You For Your Business!', align: :center, size: 20, style: :bold
  end
end
