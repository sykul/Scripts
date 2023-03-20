#    Create a template slide in PowerPoint with the desired style and layout.
#    Export the template slide as an XML file. This will give you the basic structure of a PowerPoint slide.
#    Write a script to read in the spreadsheet of fields and create a new XML file for each slide with the appropriate content.
#    Use a tool like Open XML SDK to convert the XML files into the desired PowerPoint format (e.g., pptx).

import openpyxl
from pptx import Presentation
from pptx.util import Inches

# Load data from spreadsheet
wb = openpyxl.load_workbook('presentation_data.xlsx')
ws = wb.active

# Create new presentation
prs = Presentation()

# Iterate through rows in spreadsheet and create new slides
for row in ws.iter_rows(min_row=2, values_only=True):
    slide = prs.slides.add_slide(prs.slide_layouts[0])
    slide.shapes.title.text = row[0]
    body_shape = slide.shapes.placeholders[1]
    tf = body_shape.text_frame
    tf.text = row[1]

# Save presentation
prs.save('my_presentation.pptx')
