module.exports = {
  port: 7654,
  cluster: true,
  mail: require('./cfg/mail'),
  mandrill: require('./cfg/mandrill')
};
