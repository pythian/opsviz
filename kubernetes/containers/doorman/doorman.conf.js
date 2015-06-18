module.exports = {
  // port to listen on
  port: 80,

  proxyTo: {
    host: 'localhost',
    port: 8080
  },

  sessionSecret: 'INSECURE_s5oN(TgnEUl-dbOQgr*GX2kaAp1v0M&L=_IysruEFEf',
  sessionCookieMaxAge: 4 * 24 * 60 * 60 * 1000, // milliseconds until session cookie expires (or "false" to not expire)
  // sessionCookieDomain: '.example.com', // optional cookie domain, default is not set

  // Paths that bypass doorman and do not need any authentication.  Matches on the
  // beginning of paths; for example '/about' matches '/about/me'.  Regexes are also supported.
  // publicPaths: [
  //   '/about/',
  //   '/robots.txt',
  //   /(.*?).png$/
  // ],

  modules: {
    // Register a new oauth app on Github at
    // https://github.com/account/applications/new

    password: {
     token: "Love Your Data" // any user that knows this can log in
    },


    // Register a new oauth app on Google Apps at
    // https://code.google.com/apis/console
    // google: {
    //   appId: 'YOUR-GOOGLE-CLIENT-ID',
    //   appSecret: 'YOUR-GOOGLE-CLIENT-SECRET',
    //   requiredDomain: 'yourdomain.com'
    // }
  }
};
