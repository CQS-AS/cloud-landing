module.exports = {
  port: 3000,
  cluster: false,
  mail: require('./cfg/mail'),
  mandrill: require('./cfg/mandrill')
};
