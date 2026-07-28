const Waitlist = require('../models/Waitlist');
const Contact = require('../models/Contact');

const joinWaitlist = async (req, res, next) => {
  try {
    const { email } = req.body;

    const existing = await Waitlist.findOne({ email });
    if (existing) {
      return res.status(200).json({
        success: true,
        message: "You are already on the PolicyPal waitlist! We'll notify you soon.",
      });
    }

    await Waitlist.create({ email });

    res.status(201).json({
      success: true,
      message: "Thank you for joining the PolicyPal waitlist! We'll keep you updated.",
    });
  } catch (error) {
    next(error);
  }
};

const submitContact = async (req, res, next) => {
  try {
    const { name, email, subject, message } = req.body;

    const contact = await Contact.create({
      name,
      email,
      subject: subject || 'General Inquiry',
      message,
    });

    res.status(201).json({
      success: true,
      message: 'Message received. The PolicyPal team will get back to you shortly.',
      data: contact,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  joinWaitlist,
  submitContact,
};
