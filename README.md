## Reference implementation for CQS Cloud

This is a reference implementation for the CQS Cloud projects. It defines the basic styles
and shows the structure and organisation of the codebase as well as the tools that are used.



## Initial Checkout

Once you have the branch cloned. The following steps are needed:

1. Install the npm modules

		npm install

2. Install the submodules via the `gitPullWithSub` task

 		grunt gitPullWithSub



## Execution

It is assumed that in production forever would be used, it is not included here as a module. To execute,

		node dist/server.js dev

The 'dev' parameter refers to the configuration (src/server/cfg/dev.ts), as distributed in dist/cfg/*.js
