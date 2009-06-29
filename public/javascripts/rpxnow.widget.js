if ((typeof RPXNOW == "undefined") || !RPXNOW) {
    var RPXNOW = {
        'loaded': false,
        'show': function() {
            RPXNOW.show_on_load = true;
        },
        'always_open': false,
        'overlay': false,
        'language_preference': null,
        'default_provider': null,
        'lso_submit_action': null,
        'token_url': null,
        'realm': null,
        'domain': null,
        'flags': null,
        'email': null,
        'openid_proxy_url': null
    };
}

(function () {
    var token_url_regex = /^https?:\/\/([a-z0-9]([-a-z0-9]*[a-z0-9])?\.)*[a-z0-9]([-a-z0-9]*[a-z0-9])?(:[0-9]+)?\/[^?#]*(\?[^#]*)?$/i;
    var lso_submit_action_regex = /^https:\/\/([a-z0-9]([-a-z0-9]*[a-z0-9])?\.)*[a-z0-9]([-a-z0-9]*[a-z0-9])?(:[0-9]+)?\/[^?#]*(\?[^#]*)?$/i;

    function log(msg) {
        if (window.console) {window.console.log('RPXNow: ' + msg);}
    }

    function detectPlatform() {
        var o={
            ie:0,
            opera:0,
            gecko:0,
            webkit: 0,
            mobile: null,
            air: 0
        };
        var ua=navigator.userAgent, m;

        // Modern KHTML browsers should qualify as Safari X-Grade
        if ((/KHTML/).test(ua)) {
            webkit=1;
        }
        // Modern WebKit browsers are at least X-Grade
        m=ua.match(/AppleWebKit\/([^\s]*)/);
        if (m&&m[1]) {
            o.webkit=parseFloat(m[1]);

            // Mobile browser check
            if (/ Mobile\//.test(ua)) {
                o.mobile = "Apple"; // iPhone or iPod Touch
            } else {
                m=ua.match(/NokiaN[^\/]*/);
                if (m) {
                    o.mobile = m[0]; // Nokia N-series, ex: NokiaN95
                }
            }

            m=ua.match(/AdobeAIR\/([^\s]*)/);
            if (m) {
                o.air = m[0]; // Adobe AIR 1.0 or better
            }

        }

        if (!o.webkit) { // not webkit
            // @todo check Opera/8.01 (J2ME/MIDP; Opera Mini/2.0.4509/1316; fi; U; ssr)
            m=ua.match(/Opera[\s\/]([^\s]*)/);
            if (m&&m[1]) {
                o.opera=parseFloat(m[1]);
                m=ua.match(/Opera Mini[^;]*/);
                if (m) {
                    o.mobile = m[0]; // ex: Opera Mini/2.0.4509/1316
                }
            } else { // not opera or webkit
                m=ua.match(/MSIE\s([^;]*)/);
                if (m&&m[1]) {
                    o.ie=parseFloat(m[1]);
                } else { // not opera, webkit, or ie
                    m=ua.match(/Gecko\/([^\s]*)/);
                    if (m) {
                        o.gecko=1; // Gecko detected, look for revision
                        m=ua.match(/rv:([^\s\)]*)/);
                        if (m&&m[1]) {
                            o.gecko=parseFloat(m[1]);
                        }
                    }
                }
            }
        }

        return o;
    }

    var platform = detectPlatform();
    var quirksMode = document.compatMode != 'CSS1Compat';

    function getViewportHeight() {
        var height = self.innerHeight; // Safari, Opera
        var mode = document.compatMode;

        if ( (mode || isIE) && !platform.opera ) { // IE, Gecko
            height = (mode == 'CSS1Compat') ?
                document.documentElement.clientHeight : // Standards
                document.body.clientHeight; // Quirks
        }

        return height;
    }

    function getViewportWidth() {
        var width = self.innerWidth;  // Safari
        var mode = document.compatMode;

        if (mode || isIE) { // IE, Gecko, Opera
            width = (mode == 'CSS1Compat') ?
                document.documentElement.clientWidth : // Standards
                document.body.clientWidth; // Quirks
        }
        return width;
    }

    function getDocumentHeight() {
        var scrollHeight = quirksMode ? document.body.scrollHeight : document.documentElement.scrollHeight;
        var h = Math.max(scrollHeight, getViewportHeight());
        return h;
    }

    function getDocumentWidth() {
        var scrollWidth = quirksMode ? document.body.scrollWidth : document.documentElement.scrollWidth;
        var w = Math.max(scrollWidth, getViewportWidth());
        return w;
    }

    function append_close_link(container, text) {
        var closelink = document.createElement("div");
        closelink.appendChild(document.createTextNode(text));

        s = closelink.style;
        s.color = "#111";
        s.fontWeight = "bold";
        s.fontSize = "13px";
        s.fontFamily = "arial, sans-serif";
        s.textAlign = "right";
        s.height = "16px";
        s.cursor = "pointer";
        s.position = "absolute";
        s.right = "20px";
        s.top = "20px";

        container.appendChild(closelink);
    }

    function gen_signin_url(token_url, domain) {
        if (!token_url_regex.test(token_url)) {
            console.log("Error - token_url must be an absolute URL with no fragment.");
        }

        var lso_submit_action = null;
        if (RPXNOW.lso_submit_action) {
            if (lso_submit_action_regex.test(RPXNOW.lso_submit_action)) {
                lso_submit_action = RPXNOW.lso_submit_action;
            } else {
                console.log("Error - RPXNOW.lso_submit_action must be an absolute HTTPS URL with no fragment.");
            }
        }

        var host = null;
        var rp_id = null;



        if (RPXNOW.rp_id) {
            host = "rpxnow.com";
            rp_id = RPXNOW.rp_id;
        } else if (RPXNOW.domain) {
            host = RPXNOW.domain;
        } else if (RPXNOW.realm) {
            if (RPXNOW.realm.match(/\./)) {
                host = RPXNOW.realm;
            } else {
                host = RPXNOW.realm + "." + "rpxnow.com";
            }
        } else if (domain) {
            host = domain;
        }

        var signin_url = null;
        if (lso_submit_action) {
            signin_url = "https://" + host + "/openid/lso_popup?token_url=" + encodeURIComponent(token_url) + "&lso_submit_action=" + encodeURIComponent(lso_submit_action);
        } else {
            signin_url = "https://" + host + "/openid/popup?token_url=" + encodeURIComponent(token_url);
        }

        if (rp_id) {
            signin_url += "&rp_id=" + encodeURIComponent(rp_id);
        }

        var common_ui_params = ["token_url","language_preference","user_identifier","flags","default_provider","email","openid_proxy_url"];

        var ofi = 0;
        for (ofi = 0; ofi < common_ui_params.length; ofi++) {
            var fieldname = common_ui_params[ofi];
            if (fieldname != 'token_url' && RPXNOW[fieldname]) {
                signin_url += '&' + fieldname + '=' + encodeURIComponent(RPXNOW[fieldname]);
            }
        }

        return signin_url;
    }

    var loading_strings =
        {"de":"Lade","cs":"Na\u010d\u00edt\u00e1n\u00ed","it":"Caricamento","sr":"U\u010ditavam","sv-SE":"Laddar","es":"Cargando","vi":"\u0110ang t\u1ea3i","el":"loading","fr":"Chargement","ja":"\u8aad\u307f\u8fbc\u3093\u3067\u3044\u307e\u3059","en":"Loading","hu":"Bet\u00f6lt\u00e9s","da":"Indl\u00e6ser","ko":"\ub85c\ub529","zh":"\u8f7d\u5165\u4e2d","nl":"Laden","pl":"Loading","pt-BR":"Carregando","bg":"\u0417\u0430\u0440\u0435\u0436\u0434\u0430\u043d\u0435","ru":"\u0418\u0434\u0435\u0442 \u0437\u0430\u0433\u0440\u0443\u0437\u043a\u0430","pt":"Carregando","ro":"\u00cenc\u0103rcare"};

    function gen_popup() {
        var IE6 = false /*@cc_on || @_jscript_version <= 5.6 @*/;

        function LoginBox() {
            var s = null;
            var loading_str = loading_strings[RPXNOW.language_preference];
            if (!loading_str) {
                loading_str = loading_strings['en'];
            }

            this.createIFrame = function() {
                var ifrm = document.createElement('iframe');
                ifrm.frameBorder = 0; ifrm.scrolling = 'no';
                ifrm.src = "javascript:'<html style=\"margin: 0px; padding: 0px;\"><body style=\"margin: 0px; padding: 0px;background-color: #F6F6F6; \"><h3 style=\"font-family: sans-serif; margin: 0px; padding: 0.65em; *padding: 0.45em; color: #111; \">" + loading_str + "...</h3></body></html>'";

                s = ifrm.style;
                s.width = '400px'; s.height = '40px'; s.margin = '0px';
                s.padding = '0px'; s.border = '0px'; s.position = 'absolute';
                s.top = '20px'; s.left = '20px';
                if (this.ifrm) {
                    this.container.replaceChild(ifrm, this.ifrm);
                }
                this.ifrm = ifrm;
            };

            this.container = document.createElement("div");
            this.container.className = "rpx_popup_container";
            s = this.container.style;
            var bg_prefix = RPXNOW.lso_submit_action ? 'popup_bg_lso' : 'popup_bg';
            var bg_suffix = (IE6) ? '.gif' : '.png';
            s.backgroundImage = "url(https:\/\/rpxnow.com\/images\/" + bg_prefix + bg_suffix + ")";
            s.backgroundColor = "transparent";
            s.position = "relative";
            s.width = '440px';

            // Temporary placeholder
            this.ifrm = this.container.appendChild(document.createElement('span'));
            if (!RPXNOW.always_open) {
                append_close_link(this.container, "[X]");
            }

            // NOTE: The code below is added specifically for crantastic.org
            var skiplink = document.createElement("a");

            skiplink.setAttribute('href', "/login?show_rpx=false");
            skiplink.innerHTML = "(Login without RPX)";

            s = skiplink.style;
            s.color = "#111";
            s.fontWeight = "bold";
            s.fontSize = "13px";
            s.fontFamily = "arial, sans-serif";
            s.textAlign = "right";
            s.height = "16px";
            s.cursor = "pointer";
            s.position = "absolute";
            s.right = "50px";
            s.top = "20px";

            this.container.appendChild(skiplink);
            // End of custom code

            var td = document.createElement("td");
            s = td.style;
            s.padding = "0px";
            s.margin = "0px";
            s.border = "0px";
            s.borderCollapse = "collapse";
            s.borderSpacing = "0";
            s.borderColor ="#FFF";
            s.color ="#FFF";
            s.backgroundColor = "transparent";
            td.appendChild(this.container);

            var tr = document.createElement("tr");
            tr.style.backgroundColor = "transparent";
            tr.appendChild(td);

            this.tbody = document.createElement("tbody");
            this.tbody.style.backgroundColor = "transparent";
            this.tbody.appendChild(tr);

            this.table = document.createElement("table");
            this.table.className = "rpx_popup_table";
            s = this.table.style;
            s.borderCollapse = "collapse";
            s.backgroundColor = "transparent";
            s.margin = "auto";
            this.table.appendChild(this.tbody);

            this.outer = document.createElement("div");
            this.outer.className = "rpx_popup_overlay";
            s = this.outer.style;
            s.zIndex = 10000;
            s.backgroundColor = "transparent";

            var fromTop = 125 + "px";
            if (IE6) {
                s.position = "absolute";
                s.top = document.body.scrollTop + "px";
                var outer = this.outer;
                window.attachEvent("onscroll", function () {
                        var iebody = quirksMode ? document.body : document.documentElement;
                        outer.style.top = iebody.scrollTop + "px";
                    });
            } else {
                s.position = "fixed";
                s.top = "0px";
            }
            s.overflow = "visible";
            s.display = "none";s.textAlign = "center";
            s.left = "0px";
            s.paddingLeft = (getDocumentWidth() / 3) + "px"; // NOTE: custom for crantastic.org
            s.height = getDocumentHeight() + "px";
            s.width = getDocumentWidth() + "px";

            s.paddingTop = fromTop;
            if (RPXNOW.overlay && !IE6) {
                s.backgroundImage = "url(https:\/\/rpxnow.com\/images\/overlay.png)";
                if (IE6) {
                    s.behavior = "url(https:\/\/rpxnow.com\/stylesheets\/iepngfix.htc)";
                }
            }

            this.outer.appendChild(this.table);

            if (document.body.firstChild) {
                document.body.insertBefore(this.outer,document.body.firstChild);
            } else {
                document.body.appendChild(this.outer);
            }

            var outer = this.outer;
        }

        _ = LoginBox.prototype = {}
        _.show = function (token_url, domain) {
            var outer = this.outer;
            var url = gen_signin_url(token_url, domain);
            if (!url) {
                return;
            }
            var new_iframe = this.loaded_token_url != url;
            if (new_iframe) {
                this.createIFrame();
                this.loaded_token_url = url;
            }
            var ifrm = this.ifrm;
            var container = this.container;

            function grow(i, fin_height) {
                if ((platform.ie > 0 && platform.ie < 7) ||
                    RPXNOW.show_on_load || RPXNOW.always_open) {
                    ifrm.style.height = fin_height + 'px';
                    container.style.height = (fin_height + 40) + 'px';
                } else {
                    ifrm.style.height = i + 'px';
                    container.style.height = (i + 40) + 'px';
                    if (i < fin_height) {
                        setTimeout(function() {
                                grow(i + 20, fin_height);
                            }, 3);
                    }
                }
            }

            function fireShow() {
                outer.style.display = 'block';
            }

            setTimeout(fireShow, 1);
            setTimeout(function() {
                if (new_iframe) {
                    ifrm.contentWindow.location.replace(url);
                }

                var fin_height = (RPXNOW.lso_submit_action && lso_submit_action_regex.test(RPXNOW.lso_submit_action)) ? 320 : 260;
                grow(40, fin_height);
            }, 1);

            return false;
        }

        _.hide = function () {
            this.outer.style.display = "none";
        }

        _.resize = function () {
            var outer = this.outer;
            outer.style.height = getViewportHeight() + "px";
            outer.style.width = getViewportWidth() + "px";

            setTimeout(function () {
                    outer.style.height = getDocumentHeight() + "px";
                    outer.style.width = getDocumentWidth() + "px";
            }, 1);
        }

        var login_box = new LoginBox();
        RPXNOW.show = function (token_url, domain) {
            if (typeof(token_url) === 'undefined') {
                token_url = RPXNOW.token_url;
            }
            if (!token_url) {
                console.log("Error - RPXNOW.token_url is undefined.");
            }
            login_box.show(token_url, domain);
            return false;
        }

        function getQueryStringValue(url_str, key) {
            var match = null;
            var query_str = url_str.match(/^[^?]*(?:\?([^#]*))?(?:$|#.*$)/)[1]
            // This regex has mutable state changed by the exec call.
            // Re-create it each time getQueryStringValue is called
            var _query_regex = new RegExp("([^=]+)=([^&]*)&?", "g");
            while ((match = _query_regex.exec(query_str)) != null)
            {
                if (decodeURIComponent(match[1]) == key) {
                    return decodeURIComponent(match[2]);
                }
            }
            return null;
        }

        function hookPopupToRpxLink(element) {
            var token_url = undefined;
            var domain = undefined;
            var href = oElement.href;
            if (!RPXNOW.token_url) {
                token_url = getQueryStringValue(href, "token_url");
            }

            var domain_match = href.match(/https?:\/\/([^\/]+)/)
            if (domain_match != null) {
                domain = domain_match[1];
            }

            oElement.onclick = function () {
                return RPXNOW.show(token_url, domain);
            }
        }

        // hook an onclick listener into all links with class rpxnow
        var arrElements = document.getElementsByTagName("a");
        var oRegExp = new RegExp("(^|\\s)rpxnow(\\s|$)");

        for(var i=0; i<arrElements.length; i++) {
            var oElement = arrElements[i];
            if(oRegExp.test(oElement.className)) {
                hookPopupToRpxLink(oElement);
            }
        }

        if (!RPXNOW.always_open) {
            var close_hook = function() { if (login_box) { login_box.hide(); } };

            if (window.ActiveXObject) {
                document.body.parentNode.attachEvent('onclick', close_hook);
            } else {
                document.body.parentNode.addEventListener('click',
                                                          close_hook, false);
            }
        }

        if (RPXNOW.show_on_load || RPXNOW.always_open) {
            RPXNOW.show();
        }

        function resizeLoginBox(evt) {
            if (login_box) {
                login_box.resize();
            }
        }

        if (window.ActiveXObject) {
            window.attachEvent('onresize', resizeLoginBox);
        } else {
            window.addEventListener('resize', resizeLoginBox, false);
        }
    }

    if (window.ActiveXObject) {
        window.attachEvent('onload', gen_popup);
    } else {
        window.addEventListener('load', gen_popup, false);
    }
})();
