class PdfTestingService
  def self.generate_pdf
    Prawn::Document.new do |pdf|
      # Set the title
      pdf.text "Report Title", size: 24, style: :bold
      pdf.move_down 20

      # Data for the table
      data = [
        ["Header 1", "Header 2", "Header 3", "Header 4"],
        [
          "Row 1, Col 1",
          make_nested_table_for_cell(pdf),  # Nested table inside this cell
          "Row 1, Col 3",
          "Row 1, Col 4",
        ],
        ["Row 2, Col 1", "Row 2, Col 2", "Row 2, Col 3", "Row 2, Col 4"],
        ["Row 3, Col 1", "Row 3, Col 2", "Row 3, Col 3", "Row 3, Col 4"],
      ]

      # Create the main table spanning the width of the PDF
      pdf.table(data, width: pdf.bounds.width) do
        row(0).font_style = :bold  # Make the header row bold
        self.header = true  # Treat the first row as header
        self.row_colors = ["DDDDDD", "FFFFFF"]  # Alternate row colors
      end

      pdf.move_down 20
      pdf.text "This table spans the full width of the PDF page, with Row 1, Col 2 split horizontally."
    end

    # Method to create a nested table in "Row 1, Col 2"

  end
  def self.make_nested_table_for_cell(pdf)
    # Create a small table with two rows for the nested content
    nested_data = [
      ["Upper text in Col 2"],  # First row
      ["Lower text in Col 2"],   # Second row
    ]

    # Return the nested table with a horizontal border on the first row (the separator)
    pdf.make_table(nested_data, cell_style: { borders: [] }) do
      # Add a bottom border only to the first row to create a horizontal separator
      row(0).borders = [:bottom]
      row(0).border_width = 1
      row(0).border_color = "000000"  # Black color for the horizontal line
    end
  end
end
