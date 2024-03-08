位于(1, 1)的HunterBeliefs,前进时会将(1,2)和(2,1)加入fat_gold
_{ certain_eternals:_{ cells:[ _{x:0,y:0},
					  _{x:1,y:0},
					  _{x:2,y:0},
					  _{x:3,y:0},
					  _{x:4,y:0},
					  _{x:5,y:0},
					  _{x:0,y:1},
					  _{x:1,y:1},
					  _{x:2,y:1},
					  _{x:3,y:1},
					  _{x:4,y:1},
					  _{x:5,y:1},
					  _{x:0,y:2},
					  _{x:1,y:2},
					  _{x:2,y:2},
					  _{x:3,y:2},
					  _{x:4,y:2},
					  _{x:5,y:2},
					  _{x:0,y:3},
					  _{x:1,y:3},
					  _{x:2,y:3},
					  _{x:3,y:3},
					  _{x:4,y:3},
					  _{x:5,y:3},
					  _{x:0,y:4},
					  _{x:1,y:4},
					  _{x:2,y:4},
					  _{x:3,y:4},
					  _{x:4,y:4},
					  _{x:5,y:4},
					  _{x:0,y:5},
					  _{x:1,y:5},
					  _{x:2,y:5},
					  _{x:3,y:5},
					  _{x:4,y:5},
					  _{x:5,y:5}
					],
				  eat_exit:_{c:_{x:1,y:1},e:_{id:exit}},
				  eat_walls:[ _{ c:_{x:5,y:5},
						 w:_{id:wall20}
					       },
					      _{ c:_{x:4,y:5},
						 w:_{id:wall19}
					       },
					      _{ c:_{x:3,y:5},
						 w:_{id:wall18}
					       },
					      _{ c:_{x:2,y:5},
						 w:_{id:wall17}
					       },
					      _{ c:_{x:1,y:5},
						 w:_{id:wall16}
					       },
					      _{ c:_{x:0,y:5},
						 w:_{id:wall15}
					       },
					      _{ c:_{x:5,y:4},
						 w:_{id:wall14}
					       },
					      _{ c:_{x:0,y:4},
						 w:_{id:wall13}
					       },
					      _{ c:_{x:5,y:3},
						 w:_{id:wall12}
					       },
					      _{ c:_{x:0,y:3},
						 w:_{id:wall11}
					       },
					      _{ c:_{x:5,y:2},
						 w:_{id:wall10}
					       },
					      _{ c:_{x:0,y:2},
						 w:_{id:wall9}
					       },
					      _{ c:_{x:5,y:1},
						 w:_{id:wall8}
					       },
					      _{ c:_{x:0,y:1},
						 w:_{id:wall7}
					       },
					      _{ c:_{x:5,y:0},
						 w:_{id:wall6}
					       },
					      _{ c:_{x:4,y:0},
						 w:_{id:wall5}
					       },
					      _{ c:_{x:3,y:0},
						 w:_{id:wall4}
					       },
					      _{ c:_{x:2,y:0},
						 w:_{id:wall3}
					       },
					      _{ c:_{x:1,y:0},
						 w:_{id:wall2}
					       },
					      _{ c:_{x:0,y:0},
						 w:_{id:wall1}
					       }
					    ]
				},
	      certain_fluents:_{ alive:[_{id:hunter}],
				 dir:[_{d:north,h:_{id:hunter}}],
				 fat_gold:[],
				 fat_hunter:_{ c:_{x:1,y:1},
					       h:_{id:hunter}
					     },
				 game_state:running,
				 has_arrow:[ _{ a:_{id:arrow1},
						h:_{id:hunter}
					      }
					   ],
				 has_gold:[],
				 score:0,
				 visited:[]
			       },
	      step:0,
	      uncertain_eternals:_{eat_pit:[],eat_wumpus:[]},
	      uncertain_fluents:_{fatal:[]}
	    }
位于(1, 2)的HunterBeliefs, 请求行动时会将(1,3)(2,2)加入eat_wumpus
_{certain_eternals:_{cells:[_{x:0, y:0}, _{x:1, y:0}, _{x:2, y:0}, _{x:3, y:0}, _{x:4, y:0}, _{x:5, y:0}, _{x:0, y:1}, _{x:1, y:1}, _{x:2, y:1}, _{x:3, y:1}, _{x:4, y:1}, _{x:5, y:1}, _{x:0, y:2}, _{x:1, y:2}, _{x:2, y:2}, _{x:3, y:2}, _{x:4, y:2}, _{x:5, y:2}, _{x:0, y:3}, _{x:1, y:3}, _{x:2, y:3}, _{x:3, y:3}, _{x:4, y:3}, _{x:5, y:3}, _{x:0, y:4}, _{x:1, y:4}, _{x:2, y:4}, _{x:3, y:4}, _{x:4, y:4}, _{x:5, y:4}, _{x:0, y:5}, _{x:1, y:5}, _{x:2, y:5}, _{x:3, y:5}, _{x:4, y:5}, _{x:5, y:5}], eat_exit:_{c:_{x:1, y:1}, e:_{id:exit}}, eat_walls:[_{c:_{x:5, y:5}, w:_{id:wall20}}, _{c:_{x:4, y:5}, w:_{id:wall19}}, _{c:_{x:3, y:5}, w:_{id:wall18}}, _{c:_{x:2, y:5}, w:_{id:wall17}}, _{c:_{x:1, y:5}, w:_{id:wall16}}, _{c:_{x:0, y:5}, w:_{id:wall15}}, _{c:_{x:5, y:4}, w:_{id:wall14}}, _{c:_{x:0, y:4}, w:_{id:wall13}}, _{c:_{x:5, y:3}, w:_{id:wall12}}, _{c:_{x:0, y:3}, w:_{id:wall11}}, _{c:_{x:5, y:2}, w:_{id:wall10}}, _{c:_{x:0, y:2}, w:_{id:wall9}}, _{c:_{x:5, y:1}, w:_{id:wall8}}, _{c:_{x:0, y:1}, w:_{id:wall7}}, _{c:_{x:5, y:0}, w:_{id:wall6}}, _{c:_{x:4, y:0}, w:_{id:wall5}}, _{c:_{x:3, y:0}, w:_{id:wall4}}, _{c:_{x:2, y:0}, w:_{id:wall3}}, _{c:_{x:1, y:0}, w:_{id:wall2}}, _{c:_{x:0, y:0}, w:_{id:wall1}}]}, certain_fluents:_{dir:[_{d:north, h:_{}}], fat_gold:[_{x:2, y:1}, _{x:1, y:2}], fat_hunter:_{c:c{x:1, y:2}, h:_{}}, visited:[_{from:_{x:1, y:1}, to:_{x:1, y:2}}]}, uncertain_eternals:_{eat_pit:[], eat_wumpus:[_{x:1, y:3}, _{x:2, y:2}]}}

位于(2, 1)的HunterBeliefs,请求行动时会将(2,2)加入fat_gold,(3,1)加入eat_pit,将(2,2)移出eat_wumpus
_{certain_eternals:_{cells:[_{x:0, y:0}, _{x:1, y:0}, _{x:2, y:0}, _{x:3, y:0}, _{x:4, y:0}, _{x:5, y:0}, _{x:0, y:1}, _{x:1, y:1}, _{x:2, y:1}, _{x:3, y:1}, _{x:4, y:1}, _{x:5, y:1}, _{x:0, y:2}, _{x:1, y:2}, _{x:2, y:2}, _{x:3, y:2}, _{x:4, y:2}, _{x:5, y:2}, _{x:0, y:3}, _{x:1, y:3}, _{x:2, y:3}, _{x:3, y:3}, _{x:4, y:3}, _{x:5, y:3}, _{x:0, y:4}, _{x:1, y:4}, _{x:2, y:4}, _{x:3, y:4}, _{x:4, y:4}, _{x:5, y:4}, _{x:0, y:5}, _{x:1, y:5}, _{x:2, y:5}, _{x:3, y:5}, _{x:4, y:5}, _{x:5, y:5}], eat_exit:_{c:_{x:1, y:1}, e:_{id:exit}}, eat_walls:[_{c:_{x:5, y:5}, w:_{id:wall20}}, _{c:_{x:4, y:5}, w:_{id:wall19}}, _{c:_{x:3, y:5}, w:_{id:wall18}}, _{c:_{x:2, y:5}, w:_{id:wall17}}, _{c:_{x:1, y:5}, w:_{id:wall16}}, _{c:_{x:0, y:5}, w:_{id:wall15}}, _{c:_{x:5, y:4}, w:_{id:wall14}}, _{c:_{x:0, y:4}, w:_{id:wall13}}, _{c:_{x:5, y:3}, w:_{id:wall12}}, _{c:_{x:0, y:3}, w:_{id:wall11}}, _{c:_{x:5, y:2}, w:_{id:wall10}}, _{c:_{x:0, y:2}, w:_{id:wall9}}, _{c:_{x:5, y:1}, w:_{id:wall8}}, _{c:_{x:0, y:1}, w:_{id:wall7}}, _{c:_{x:5, y:0}, w:_{id:wall6}}, _{c:_{x:4, y:0}, w:_{id:wall5}}, _{c:_{x:3, y:0}, w:_{id:wall4}}, _{c:_{x:2, y:0}, w:_{id:wall3}}, _{c:_{x:1, y:0}, w:_{id:wall2}}, _{c:_{x:0, y:0}, w:_{id:wall1}}]}, certain_fluents:_{dir:[_{d:east, h:_{}}], fat_gold:[_{x:2, y:1}, _{x:1, y:2}, _{x:2, y:2}], fat_hunter:_{c:c{x:2, y:1}, h:_{}}, visited:[_{from:_{x:1, y:1}, to:_{x:1, y:2}},_{from:_{x:2, y:1}, to:_{x:1, y:1}},_{from:_{x:1, y:1}, to:_{x:2, y:1}}]}, uncertain_eternals:_{eat_pit:[_{x:3, y:1}], eat_wumpus:[_{x:1, y:3}]}}



f(HunterBeliefs, Action)

effect_move(HunterBeliefs, NewBeliefs):-向前移动要做的事，更新自身位置和visited