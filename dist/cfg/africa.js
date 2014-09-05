module.exports = {
  port: 7655,
  cluster: true,
  mail: require('./cfg/mail-africa'),
  mandrill: require('./cfg/mandrill')
};
