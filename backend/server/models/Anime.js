const mongoose = require('mongoose');
const EpisodeSchema = new mongoose.Schema({ number: { type: Number, required: true }, videoUrl: { type: String, required: true } });
const AnimeSchema = new mongoose.Schema({
  title: { type: String, required: true },
  synopsis: { type: String, default: '' },
  coverImage: { type: String, default: '' },
  status: { type: String, default: 'Ongoing' },
  episodes: [EpisodeSchema],
  createdAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('Anime', AnimeSchema);
