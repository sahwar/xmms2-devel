"""
Python bindings for XMMS2.
"""

cdef extern from "string.h" :
	int strcmp (signed char *s1, signed char *s2)

cdef extern from "internal/xlist-int.h" :
	ctypedef struct x_list_t :
		void *data
		x_list_t *next
		x_list_t *prev

cdef extern from "internal/xhash-int.h" :
	ctypedef struct x_hash_t

	ctypedef object (*XHFunc) (signed char *key, signed char *value, object user_data)

	void x_hash_foreach (x_hash_t *hash_table, XHFunc func, object user_data)

# Actually we don't want a GLib Mainloop here. but for the time beeing....
cdef extern from "glib.h" :
	ctypedef struct GMainContext
	ctypedef struct GMainLoop

	void g_main_loop_run (GMainLoop *loop)
	GMainLoop *g_main_loop_new (GMainContext *context, signed int is_running)

cdef extern from "internal/client_ipc.h" :
	ctypedef struct xmmsc_ipc_t

	int xmmsc_ipc_io_in_callback (xmmsc_ipc_t *ipc)
	int xmmsc_ipc_fd_get (xmmsc_ipc_t *ipc)
	void xmmsc_ipc_disconnect (xmmsc_ipc_t *ipc)
	void xmmsc_ipc_error_set (xmmsc_ipc_t *ipc, char *error)

cdef extern from "internal/xmmsclient_int.h" :
	ctypedef struct xmmsc_connection_t :
		xmmsc_ipc_t *ipc
	
cdef extern from "xmms/xmmsclient.h" :

	ctypedef struct xmmsc_result_t
	ctypedef object (*xmmsc_result_notifier_t) (xmmsc_result_t *res, object user_data)

	xmmsc_result_t *xmmsc_result_restart (xmmsc_result_t *res)
	void xmmsc_result_ref (xmmsc_result_t *res)
	void xmmsc_result_unref (xmmsc_result_t *res)
	void xmmsc_result_notifier_set (xmmsc_result_t *res, xmmsc_result_notifier_t func, object user_data)
	void xmmsc_result_wait (xmmsc_result_t *res)
	signed int xmmsc_result_iserror (xmmsc_result_t *res)
	signed char *xmmsc_result_get_error (xmmsc_result_t *res)
	int xmmsc_result_cid (xmmsc_result_t *res)

	signed int xmmsc_result_get_int (xmmsc_result_t *res, int *r)
	signed int xmmsc_result_get_uint (xmmsc_result_t *res, unsigned int *r)
	signed int xmmsc_result_get_string (xmmsc_result_t *res, signed char **r)
	signed int xmmsc_result_get_hashtable (xmmsc_result_t *res, x_hash_t **r)
	signed int xmmsc_result_get_stringlist (xmmsc_result_t *res, x_list_t **r)
	signed int xmmsc_result_get_intlist (xmmsc_result_t *res, x_list_t **r)
	signed int xmmsc_result_get_uintlist (xmmsc_result_t *res, x_list_t **r)
	signed int xmmsc_result_get_hashlist (xmmsc_result_t *res, x_list_t **r)
	signed int xmmsc_result_get_playlist_change (xmmsc_result_t *res, unsigned int *change, unsigned int *id, unsigned int *argument)

	xmmsc_connection_t *xmmsc_init (char *clientname)
	signed int xmmsc_connect (xmmsc_connection_t *c, signed char *p)
	void xmmsc_deinit (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_quit (xmmsc_connection_t *conn)

	xmmsc_result_t *xmmsc_playlist_shuffle (xmmsc_connection_t *)
	xmmsc_result_t *xmmsc_playlist_add (xmmsc_connection_t *, char *)
	xmmsc_result_t *xmmsc_playlist_medialibadd (xmmsc_connection_t *c, char *)
	xmmsc_result_t *xmmsc_playlist_remove (xmmsc_connection_t *, unsigned int)
	xmmsc_result_t *xmmsc_playlist_clear (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_playlist_save (xmmsc_connection_t *c, char *filename)
	xmmsc_result_t *xmmsc_playlist_list (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_playlist_get_mediainfo (xmmsc_connection_t *, unsigned int)
	xmmsc_result_t *xmmsc_playlist_sort (xmmsc_connection_t *c, char *property) 
	xmmsc_result_t *xmmsc_playlist_set_next (xmmsc_connection_t *c, unsigned int type, int moment)

	xmmsc_result_t *xmmsc_broadcast_playlist_entry_changed (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_broadcast_playlist_changed (xmmsc_connection_t *c)

	
	xmmsc_result_t *xmmsc_playback_stop (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_playback_next (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_playback_start (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_playback_pause (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_playback_current_id (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_playback_seek_ms (xmmsc_connection_t *c, unsigned int milliseconds)
	xmmsc_result_t *xmmsc_playback_seek_samples (xmmsc_connection_t *c, unsigned int samples)
	xmmsc_result_t *xmmsc_playback_playtime (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_playback_status (xmmsc_connection_t *c)

	xmmsc_result_t *xmmsc_broadcast_playback_status (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_broadcast_playback_current_id (xmmsc_connection_t *c)

	xmmsc_result_t *xmmsc_signal_playback_playtime (xmmsc_connection_t *c)


	xmmsc_result_t *xmmsc_configval_set (xmmsc_connection_t *c, char *key, char *val)
	xmmsc_result_t *xmmsc_configval_list (xmmsc_connection_t *c)
	xmmsc_result_t *xmmsc_configval_get (xmmsc_connection_t *c, char *key)

	xmmsc_result_t *xmmsc_broadcast_configval_changed (xmmsc_connection_t *c)

	xmmsc_result_t *xmmsc_medialib_select (xmmsc_connection_t *conn, char *query)

cdef extern from "xmms/xmmsclient-glib.h" :
	void xmmsc_ipc_setup_with_gmain (xmmsc_connection_t *connection, GMainContext *context)

#####################################################################

from select import select

cdef foreach_hash (signed char *key, signed char *value, udata) :
	udata[key] = value

ObjectRef = {}

cdef ResultNotifier (xmmsc_result_t *res, obj) :
	obj.Callback ()
	if not obj.GetBroadcast () :
		del ObjectRef[obj.GetCid ()]
		
	
cdef class XMMSResult :
	"""
	Class containing the results of some operation
	"""
	cdef xmmsc_result_t *res
	cdef object notifier
	cdef object user_data
	cdef int cid
	cdef int broadcast

	def __new__ (self) :
		self.cid = 0

	def MoreInit (self, broadcast = 0) :
		self.cid = xmmsc_result_cid (self.res)
		self.broadcast = broadcast
		xmmsc_result_notifier_set (self.res, ResultNotifier, self)
		ObjectRef[self.cid] = self

	def GetBroadcast (self) :
		return self.broadcast

	def GetCid (self) :
		return self.cid

	def Callback (self) :
		""" Override me! """
		pass

	def _check (self) :
		if not self.res :
			raise ValueError ("The resultset did not contain a reply!")

	def Wait (self) :
		"""
		Wait for the result from the daemon.
		"""
		self._check ()
		xmmsc_result_wait (self.res)

	def GetInt (self) :
		"""
		Get data from the result structure as an int.
		@rtype: int
		"""
		cdef signed int ret
		self._check ()
		if xmmsc_result_get_int (self.res, &ret) :
			return ret
		else :
			raise ValueError

	def GetUInt (self) :
		"""
		Get data from the result structure as an unsigned int.
		@rtype: uint
		"""
		cdef unsigned int ret
		self._check ()
		if xmmsc_result_get_uint (self.res, &ret) :
			return ret
		else :
			raise ValueError

	def GetString (self) :
		"""
		Get data from the result structure as a string.
		@rtype: string
		"""
		cdef signed char *ret

		self._check ()
		if xmmsc_result_get_string (self.res, &ret) :
			return ret
		else :
			raise ValueError


	def GetHashTable (self) :
		"""
		@return: A hash table containing media info.
		"""
		cdef x_hash_t *hash
		self._check ()

		if xmmsc_result_get_hashtable (self.res, &hash) :
			ret = {}
			x_hash_foreach (hash, foreach_hash, ret)
			return ret
		else :
			raise ValueError
			
	def GetIntList (self) :
		"""
		@return: A list of ints from the result structure.
		"""
		cdef x_list_t *l
		cdef x_list_t *n

		self._check ()
		if xmmsc_result_get_intlist (self.res, &l) :
			ret = []
			n = l
			while n :
				ret.append (<signed int>n.data)
				n = n.next

			return ret
		else :
			raise ValueError

	def GetUIntList (self) :
		"""
		@return: A list of unsigned ints from the result structure.
		"""
		cdef x_list_t *l
		cdef x_list_t *n

		self._check ()
		if xmmsc_result_get_uintlist (self.res, &l) :
			ret = []
			n = l
			while n :
				ret.append (<unsigned int>n.data)
				n = n.next

			return ret
		else :
			raise ValueError

	def GetHashList (self) :
		"""
		@return: A list of dicts from the result structure.
		"""
		cdef x_list_t *l
		cdef x_list_t *n

		self._check ()
		if xmmsc_result_get_hashlist (self.res, &l) :
			ret = []
			n = l
			while n :
				hash = {}
				x_hash_foreach (<x_hash_t *>n.data, foreach_hash, hash)
				ret.append (hash)
			return ret
		else :
			raise ValueError


	def GetStringList (self) :
		"""
		@return: A list of strings from the result structure.
		"""
		cdef x_list_t *l
		cdef x_list_t *n

		self._check ()
		if xmmsc_result_get_stringlist (self.res, &l) :
			ret = []
			n = l
			while n :
				ret.append (<signed char *>n.data)
				n = n.next

			return ret
		else :
			raise ValueError

	def Restart (self) :
		cdef XMMSResult r
		r = self

		xmmsc_result_unref (r.res)
		r.res = xmmsc_result_restart (self.res)
		self.MoreInit ()
		
		return r

	def IsError (self) :
		"""
		@return: Whether the result represents an error or not.
		@rtype: Boolean
		"""
		return xmmsc_result_iserror (self.res)

	def GetError (self) :
		return xmmsc_result_get_error (self.res)

	def __dealloc__ (self) :
		"""
		Deallocate the result.
		"""

		if self.res :
			xmmsc_result_unref (self.res)

cdef class XMMS :
	cdef xmmsc_connection_t *conn

	def __new__ (self, clientname = "Python XMMSClient") :
		self.conn = xmmsc_init (clientname)

	def GLibLoop (self) :
		cdef GMainLoop *ml
		ml = g_main_loop_new (NULL, 0)
		xmmsc_ipc_setup_with_gmain (self.conn, NULL)

		g_main_loop_run (ml)

	def PythonLoop (self) :
		fd = xmmsc_ipc_fd_get (self.conn.ipc)
		while True :
			(i, o, e) = select ([fd], [], [])
			xmmsc_ipc_io_in_callback (self.conn.ipc)
		

	def Connect (self, path = None) :
		if path :
			if xmmsc_connect (self.conn, path) :
				return
		else :
			if xmmsc_connect (self.conn, NULL) :
				return

		raise IOError ("Couldn't connect to server!")

	def PlaybackStart (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playback_start (self.conn)
		ret.MoreInit ()
		
		return ret

	def PlaybackStop (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playback_stop (self.conn)
		ret.MoreInit ()
		
		return ret

	def PlaybackNext (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playback_next (self.conn)
		ret.MoreInit ()
		
		return ret

	def PlaybackPause (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playback_pause (self.conn)
		ret.MoreInit ()
		
		return ret

	def PlaybackCurrentID (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playback_current_id (self.conn)
		ret.MoreInit ()
		
		return ret

	def PlaybackSeekMS (self, ms, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playback_seek_ms (self.conn, ms)
		ret.MoreInit ()
		
		return ret

	def PlaybackSeekSamples (self, samples, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playback_seek_samples (self.conn, samples)
		ret.MoreInit ()
		
		return ret

	def BroadcastPlaybackStatus (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_broadcast_playback_status (self.conn)
		ret.MoreInit (1)
		
		return ret

	def BroadcastPlaybackCurrentID (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_broadcast_playback_current_id (self.conn)
		ret.MoreInit (1)
		
		return ret

	def SignalPlaybackPlaytime (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_signal_playback_playtime (self.conn)
		ret.MoreInit ()
		
		return ret

	def PlaylistShuffle (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_shuffle (self.conn)
		ret.MoreInit ()
		
		return ret

	def PlaylistAdd (self, url, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_add (self.conn, url)
		ret.MoreInit ()
		
		return ret

	def PlaylistMedialibAdd (self, query, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_medialibadd (self.conn, query)
		ret.MoreInit ()
		
		return ret

	def PlaylistRemove (self, id, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_remove (self.conn, id)
		ret.MoreInit ()
		
		return ret

	def PlaylistClear (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_clear (self.conn)
		ret.MoreInit ()
		
		return ret

	def PlaylistSave (self, filename, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_save (self.conn, filename)
		ret.MoreInit ()
		
		return ret

	def PlaylistList (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_list (self.conn)
		ret.MoreInit ()
		
		return ret

	def PlaylistGetMediainfo (self, id, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_get_mediainfo (self.conn, id)
		ret.MoreInit ()
		
		return ret

	def PlaylistSort (self, prop, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_sort (self.conn, prop)
		ret.MoreInit ()
		
		return ret

	def PlaylistSetNext (self, type, moment, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_playlist_set_next (self.conn, type, moment)
		ret.MoreInit ()
		
		return ret

	def BroadcastPlaylistChanged (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_broadcast_playlist_changed (self.conn)
		ret.MoreInit (1)
		
		return ret

	def BroadcastPlaylistEntryChanged (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_broadcast_playlist_entry_changed (self.conn)
		ret.MoreInit (1)
		
		return ret

	def ConfigvalSet (self, key, val, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_configval_set (self.conn, key, val)
		ret.MoreInit ()
		return ret

	def ConfigvalGet (self, key, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_configval_get (self.conn, key)
		ret.MoreInit ()
		return ret

	def ConfigvalList (self, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_configval_list (self.conn)
		ret.MoreInit ()
		return ret

	def MedialibQuery (self, query, myClass = None) :
		cdef XMMSResult ret
		
		if myClass :
			ret = myClass ()
		else :
			ret = XMMSResult ()
		
		ret.res = xmmsc_medialib_select (self.conn, query)
		ret.MoreInit ()
		return ret

