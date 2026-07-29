/**
 * PolicyPal PDF Processing Service
 * Extracts text from uploaded PDF buffers and sends to AI for structured parsing.
 */

const pdfParse = require('pdf-parse');
const { scanDocumentOCR } = require('./ai.service');

/**
 * Extract raw text from a PDF buffer.
 * @param {Buffer} pdfBuffer - The PDF file buffer from multer
 * @returns {Promise<{text: string, pageCount: number, info: object}>}
 */
const extractTextFromPDF = async (pdfBuffer) => {
  try {
    const data = await pdfParse(pdfBuffer);
    return {
      text: data.text || '',
      pageCount: data.numpages || 0,
      info: {
        title: data.info?.Title || '',
        author: data.info?.Author || '',
        creator: data.info?.Creator || '',
      },
    };
  } catch (error) {
    console.error('[PDF Service] Text extraction failed:', error.message);
    throw new Error('Failed to extract text from the PDF. The file may be corrupted, image-only, or password-protected.');
  }
};

/**
 * Full pipeline: Extract text from PDF → Send to AI for understanding → Return structured policy data.
 * @param {Buffer} pdfBuffer - The PDF file buffer
 * @param {string} filename - Original filename of the uploaded PDF
 * @returns {Promise<{extractedText: string, pageCount: number, pdfInfo: object, aiParsedPolicy: object}>}
 */
const processPolicyPDF = async (pdfBuffer, filename) => {
  // Step 1: Extract raw text from the PDF
  const { text, pageCount, info } = await extractTextFromPDF(pdfBuffer);

  if (!text || text.trim().length < 20) {
    throw new Error(
      'Could not extract meaningful text from this PDF. It may be a scanned image. ' +
      'Try uploading a text-based (digitally generated) policy document.'
    );
  }

  // Step 2: Send extracted text to AI for intelligent parsing
  const aiParsedPolicy = await scanDocumentOCR({ text, filename });

  return {
    extractedText: text,
    pageCount,
    pdfInfo: info,
    aiParsedPolicy,
  };
};

module.exports = {
  extractTextFromPDF,
  processPolicyPDF,
};
