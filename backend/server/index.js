require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const Anime = require('./models/Anime');

const app = express();
app.use(cors());
app.use(express.json());

const MONGO_URI = process.env.MONGO_URI;
const JWT_SECRET = process.env.JWT_SECRET || 'rahasia-super-panjang';
const ADMIN_USER = process.env.ADMIN_USER || 'admin';
const ADMIN_PASS = process.env.ADMIN_PASS || 'admin123';

if (!MONGO_URI) { console.error('ERROR: MONGO_URI belum diisi'); process.exit(1); }

mongoose.connect(MONGO_URI).then(() => console.log('MongoDB Connected')).catch(err => console.error(err));

function auth(req, res, next) {
  const header = req.headers.authorization;
  if (!header) return res.status(401).json({ error: 'No token' });
  try { req.user = jwt.verify(header.split(' ')[1], JWT_SECRET); next(); }
  catch { res.status(401).json({ error: 'Invalid token' }); }
}

app.get('/api/v1/anime/trending', async (req, res) => {
  try { const animes = await Anime.find().sort({ createdAt: -1 }).limit(20); res.json(animes); }
  catch (e) { res.status(500).json({ error: e.message }); }
});

app.post('/api/v1/admin/login', (req, res) => {
  const { username, password } = req.body;
  if (username === ADMIN_USER && password === ADMIN_PASS) {
    return res.json({ token: jwt.sign({ role: 'admin' }, JWT_SECRET, { expiresIn: '7d' }) });
  }
  res.status(401).json({ error: 'Wrong credentials' });
});

app.post('/api/v1/admin/anime', auth, async (req, res) => {
  try { res.status(201).json(await Anime.create(req.body)); }
  catch (e) { res.status(400).json({ error: e.message }); }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server on port ${PORT}`));
