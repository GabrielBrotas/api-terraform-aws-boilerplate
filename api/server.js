const app = require('express')();
const cors = require('cors');

app.use(cors());

app.get('/health-check', (req, res) => {
    return res.status(200).json({ success: true })
})

app.get('/', (req, res) => {
    return res.status(200).json({ success: true, version: '1.0.0' })
})

const PORT = 4000;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
})