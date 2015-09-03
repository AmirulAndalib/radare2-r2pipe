import Foundation

private func log (a:String, b:String) {
	let Color = "\u{001b}[32m"
	let Reset = "\u{001b}[0m"
	print (Color+"\(a)("+Reset+"\n\(b)"+Color+")"+Reset)
}

#if HAVE_SPAWN

private func testSpawn () {
	print ("Testing r2pipe spawn method");
	if let r2p = R2Pipe(url:"/bin/ls") {
		if let str = r2p.cmdSync ("?V") {
			log("spawn-sync", b:str)
		} else {
			print ("ERROR: spawnCmdSync");
		}
		r2p.cmd("pd 5 @ entry0", closure:{
			(str:String)->() in
			log("spawn-async", b:str)
		});
	} else {
		print ("ERROR: spawn not working\n");
	}
}

#else

private func testSpawn () {
	print ("ERROR: Compiled without spawn support")
}

#endif

private func testHttp() {
	print ("Testing r2pipe HTTP method");
	if let r2p = R2Pipe(url:"http://cloud.radare.org/cmd/") {
		if let str = r2p.cmdSync ("?V") {
			log("http-sync", b:str)
		} else {
			print ("ERROR: HTTP Sync Call failed");
		}
		r2p.cmd("pi 5 @ entry0", closure:{
			(str:String)->() in
			log ("http-async", b: str);
			exit (0);
		});
	} else {
		print ("ERROR: HTTP method");
	}
}

/* ---------------------------- */
/* --          main          -- */
/* ---------------------------- */

print("Hello r2pipe.swift!");
testSpawn();
testHttp();

/* main loop required for async network requests */
NSRunLoop.currentRunLoop().run();
