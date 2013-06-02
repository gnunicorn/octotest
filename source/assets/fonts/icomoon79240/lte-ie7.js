/* Use this script if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'icomoon\'">' + entity + '</span>' + html;
	}
	var icons = {
			'icon-twitter' : '&#xe001;',
			'icon-feed' : '&#xe002;',
			'icon-google-plus' : '&#xe003;',
			'icon-facebook' : '&#xe004;',
			'icon-linkedin' : '&#xe005;',
			'icon-html5' : '&#xe006;',
			'icon-gplus' : '&#xe007;',
			'icon-facebook-2' : '&#xe008;',
			'icon-twitter-2' : '&#xe009;',
			'icon-feed-2' : '&#xe00a;',
			'icon-github' : '&#xe00b;',
			'icon-github-2' : '&#xe00c;',
			'icon-github-3' : '&#xe00d;',
			'icon-github-4' : '&#xe00e;',
			'icon-mail' : '&#xe00f;',
			'icon-skype' : '&#xe010;',
			'icon-linkedin-2' : '&#xe011;',
			'icon-delicious' : '&#xe012;',
			'icon-xing' : '&#xe013;',
			'icon-xing-2' : '&#xe014;',
			'icon-pinterest' : '&#xe015;',
			'icon-pinterest-2' : '&#xe016;',
			'icon-chrome' : '&#xe017;',
			'icon-firefox' : '&#xe018;',
			'icon-IE' : '&#xe019;',
			'icon-safari' : '&#xe01a;',
			'icon-html5-2' : '&#xe01b;',
			'icon-BitBucket' : '&#xe01c;',
			'icon-mail-2' : '&#x35;',
			'icon-google' : '&#x21;',
			'icon-google-plus-2' : '&#x22;',
			'icon-facebook-3' : '&#x23;',
			'icon-twitter-3' : '&#x24;',
			'icon-feed-3' : '&#x25;',
			'icon-youtube' : '&#x26;',
			'icon-youtube-2' : '&#x27;',
			'icon-github-5' : '&#x28;',
			'icon-github-6' : '&#x29;',
			'icon-amazon' : '&#x2a;',
			'icon-amazon-2' : '&#x2b;',
			'icon-tux' : '&#x2c;',
			'icon-apple' : '&#x2d;',
			'icon-android' : '&#x2e;',
			'icon-windows' : '&#x2f;',
			'icon-paypal' : '&#x30;',
			'icon-paypal-2' : '&#x31;',
			'icon-paypal-3' : '&#x32;',
			'icon-css3' : '&#x33;',
			'icon-opera' : '&#x34;'
		},
		els = document.getElementsByTagName('*'),
		i, attr, html, c, el;
	for (i = 0; i < els.length; i += 1) {
		el = els[i];
		attr = el.getAttribute('data-icon');
		if (attr) {
			addIcon(el, attr);
		}
		c = el.className;
		c = c.match(/icon-[^\s'"]+/);
		if (c && icons[c[0]]) {
			addIcon(el, icons[c[0]]);
		}
	}
};