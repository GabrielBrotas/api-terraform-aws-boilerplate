const app = require('express')();
const cors = require('cors');

require('dotenv').config()

app.use(cors());

app.get('/health-check', (req, res) => {
    return res.status(200).json({ success: true })
})

app.get('/', (req, res) => {
    return res.status(200).json({ success: true, version: '1.2.1', environment: process.env.ENVIRONMENT })
})

const PORT = 4000;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
})