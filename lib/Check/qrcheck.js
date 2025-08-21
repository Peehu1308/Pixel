const QRCode = require('qrcode');
const fs=require('fs');

const generateQR = async (data) => {
  try {
    const qrDataUrl = await QRCode.toDataURL(data);
    const base64Data = qrDataUrl.replace(/^data:image\/png;base64,/, "");
    const buffer=Buffer.from(base64Data,'base64');
    fs.writeFileSync(filepath,buffer);
    console.log("QR Code saved to file successfully.");
    // return qrDataUrl;
  } catch (error) {
    console.error("Error generating QR Code:", error);
    throw error;
  }
};

// const qrcode = generateQR('https://chatgpt.com/c/68072dc6-965c-8002-b8b3-c49d3f82bb35');
const data= 'https://chatgpt.com/c/68072dc6-965c-8002-b8b3-c49d3f82bb35';
const filepath="C:/Users/peehu/Downloads/qrcode.png"

generateQR(data,filepath);

// qrcode
//   .then((url) => {
//     console.log("Generated QR Code URL:", url);
//   })
//   .catch((error) => {
//     console.error("Failed to generate QR Code:", error);
//   });