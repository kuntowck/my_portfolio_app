const express = require("express")
const bodyParser = require("body-parser")
const cors = require("cors")
const pool = require("./database")
const multer = require("multer")
const path = require("path")
const { error } = require("console")

const app = express()
const PORT = 5144

app.use(cors())
app.use(bodyParser.json())
app.use("/uploads", express.static(path.join(__dirname, "uploads")))

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/") // folder local
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname)) // nama unik
  },
})

const upload = multer({ storage })

app.get("/portfolios", async (req, res) => {
  try {
    const { category } = req.query
    let result

    // if (!category) {
    //   return res.status(400).json({ error: "Category is required" })
    // }

    if (category) {
      result = await pool.query(
        `SELECT * FROM portfolios WHERE category = $1 ORDER BY id DESC`,
        [category]
      )
    } else {
      result = await pool.query("SELECT * FROM portfolios ORDER BY id DESC")
    }

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "No portfolios found" })
    }

    res.json(result.rows)
  } catch (error) {
    console.error(error.message)
    res.status(500).json({ error: "Server error, please try again later" })
  }
})

app.get("/portfolios/:id", async (req, res) => {
  try {
    const { id } = req.params

    if (!id) {
      return res.status(400).json({ error: "Portfolio ID is required" })
    }

    result = await pool.query(
      `SELECT * FROM portfolios WHERE id = $1 ORDER BY id DESC`,
      [id]
    )

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "No portfolios found" })
    }

    res.json(result.rows)
  } catch (error) {
    console.error(error.message)
    res.status(500).json({ error: "Server error, please try again later" })
  }
})

app.post("/portfolios", async (req, res) => {
  try {
    const {
      title,
      category,
      completion_date,
      description,
      project_link,
      stack,
      image,
    } = req.body

    if (
      !title ||
      !category ||
      !completion_date ||
      !description ||
      !stack ||
      !image
    ) {
      return res.status(400).json({ error: "Missing required fields" })
    }

    if (project_link && !/^https?:\/\/.+$/.test(project_link)) {
      return res.status(400).json({ error: "Invalid project link format" })
    }

    const result = await pool.query(
      `INSERT INTO portfolios (title, category, completion_date, description, project_link, stack, image) VALUES ($1, $2, $3, $4, $5 , $6, $7) RETURNING *`,
      [
        title,
        category,
        completion_date,
        description,
        project_link || null,
        stack,
        image,
      ]
    )

    res.status(201).json(result.rows[0])
  } catch (error) {
    console.error(error.message)
    res.status(500).json({ error: "Failed to create portfolio" })
  }
})

app.post("/portfolios/uploads", upload.single("image"), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded" })
    }

    const fileUrl = `/uploads/${req.file.filename}`
    console.log(fileUrl)

    res.status(200).json({ url: fileUrl })
  } catch (error) {
    console.error(error.message)
    res.status(500).json({ error: "Failed to upload image" })
  }
})

app.put("/portfolios/:id", async (req, res) => {
  try {
    const { id } = req.params
    const {
      title,
      category,
      description,
      project_link,
      stack,
      image,
      completion_date,
    } = req.body

    if (!id) {
      res.status(400).json({ error: "Portfolio ID is required" })
    }

    if (
      !title ||
      !category ||
      !description ||
      !stack ||
      !image ||
      !completion_date
    ) {
      res.status(400).json({ error: "Missing required fields" })
    }

    const result = await pool.query(
      `UPDATE portfolios SET title=$1, category=$2, description=$3, project_link=$4, stack=$5, image=$6, completion_date=$7 WHERE id=$8 RETURNING *`,
      [
        title,
        category,
        description,
        project_link || null,
        stack,
        image,
        completion_date,
        id,
      ]
    )

    if (result.rows.length === 0) {
      console.error(error.message)
      return res.status(404).json({ error: "Portfolio not found" })
    }

    res.status(201).json(result.rows[0])
  } catch (error) {
    console.error(error.message)
    res.status(500).json({ error: "Failed to update portfolio" })
  }
})

app.delete("/portfolios/:id", async (req, res) => {
  try {
    const { id } = req.params

    if (!id) {
      res.status(400).json({ error: "Portfolio ID is required" })
    }

    const result = await pool.query(
      `DELETE FROM portfolios WHERE id = $1 RETURNING *`,
      [id]
    )

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Portfolio not found." })
    }

    res.status(200).json({ message: "Portfolio deleted succesfully" })
  } catch (error) {
    console.error(error.message)
    res.status(500).json({ error: error.message })
  }
})

// Start server
app.listen(PORT, () =>
  console.log(`Portfolio API running at http://localhost:${PORT}`)
)
