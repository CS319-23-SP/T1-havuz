const express = require('express');
const fs = require('fs');
const path = require('path');
const multer = require('multer');
const router = express.Router();

const documentsPath = path.join(__dirname, '../../Documents');

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
      cb(null, req.folderPath);
  },
  filename: function (req, file, cb) {
      cb(null, file.originalname);
  }
});

function fileFilter(req, file, cb) {
  if (file.mimetype !== 'application/pdf') {
      return cb(new Error('Only PDF files are allowed'));
  }
  cb(null, true);
}

const upload = multer({ 
  storage: storage,
  fileFilter: fileFilter
});

function createFolders(urlPath) {
  const folders = urlPath.split('/').map(folder => decodeURIComponent(folder));
    let currentPath = documentsPath;

    for (const folder of folders) {
        currentPath = path.join(currentPath, folder);
        if (!fs.existsSync(currentPath)) {
            fs.mkdirSync(currentPath);
        }
    }

    return currentPath;
}

function handlePDFUpload(req, res, next) {
    const { path: urlPath } = req.query;
    if (!urlPath) {
        return res.status(400).send('Path parameter is missing');
    }

    req.folderPath = createFolders(urlPath);

    next();
}

function isValidFilePath(filePath) {
  return fs.existsSync(filePath) && fs.statSync(filePath).isFile();
}

function createFilePath(urlPath) {
  const folders = urlPath.split('/').map(folder => decodeURIComponent(folder));
  return path.join(documentsPath, ...folders);
}

function downloadPDF(pdfPath, res) {
  const filename = path.basename(pdfPath);

  res.setHeader('Content-disposition', 'attachment; filename=' + filename);
  res.setHeader('Content-type', 'application/pdf');

  const file = fs.createReadStream(pdfPath);
  file.pipe(res);
  
}

router
  .post('/', handlePDFUpload, upload.single('pdf'), (req, res) => {
    res.status(200).send('Si señor');
  })
  .get('/', (req, res) => {
    const { path: urlPath } = req.query;
    
    if (!urlPath)
        return res.status(400).send('Path parameter is missing');

    const pdfPath = createFilePath(urlPath);

    if (!isValidFilePath(pdfPath))
      return res.status(400).send('Invalid PDF path');

    downloadPDF(pdfPath, res);
  });

module.exports = router;