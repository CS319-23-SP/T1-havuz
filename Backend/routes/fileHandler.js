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


const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024
  }
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

function handleFileUpload(req, res, next) {
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

function downloadFile(filePath, res) {
  const filename = path.basename(filePath);

  res.setHeader('Content-disposition', 'attachment; filename=' + filename);

  const fileStream = fs.createReadStream(filePath);
  fileStream.pipe(res);
  
}

function listFilesInDirectory(directoryPath) {
  return fs.readdirSync(directoryPath);
}

function deleteFile(filePath, res) {
  console.log(filePath);
  fs.unlink(filePath, (err) => {
    if (err) {
      console.error('Error deleting file:', err);
      return res.status(500).send('Error deleting file');
    }
    res.status(200).send('File deleted successfully');
  });
}

router
  .post('/', handleFileUpload, upload.single('file'), (req, res) => {
    res.status(200).send('Si señor');
  })
  .get('/', (req, res) => {
    const { path: urlPath } = req.query;

    
    if (!urlPath)
        return res.status(400).send('Path parameter is missing');

    const filePath = createFilePath(urlPath);

    if (!isValidFilePath(filePath))
      return res.status(400).send('Invalid file path');

    downloadFile(filePath, res);
  })
  .delete('/', (req, res) => {
    const { path: urlPath } = req.query;

    
    if (!urlPath)
        return res.status(400).send('Path parameter is missing');

    const filePath = createFilePath(urlPath);

    if (!isValidFilePath(filePath))
      return res.status(400).send('Invalid file path');

    deleteFile(filePath, res);
  })
  .get('/list', (req, res) => {
    const { path: urlPath } = req.query;
  
    if (!urlPath) {
      return res.status(400).send('Path parameter is missing');
    }
  
    const directoryPath = createFilePath(urlPath);
  
    try {
      const files = listFilesInDirectory(directoryPath);
      res.json(files);
    } catch (error) {
      res.status(500).send('Error listing files in directory');
    }
  });

module.exports = router;