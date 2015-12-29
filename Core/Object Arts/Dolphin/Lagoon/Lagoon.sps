<?xml version="1.0" encoding="UTF-8"?>
<structure version="2" schemafile="D:\Dev\Irp\v5\Engine\Lagoon.xsd" workingxmlfile="D:\Dev\Irp\v5\Engine\IRP.xml" templatexmlfile="">
	<xmltablesupport standard="HTML"/>
	<nspair prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
	<template>
		<match overwrittenxslmatch="/"/>
		<children>
			<template>
				<match match="Lagoon"/>
				<children>
					<paragraph paragraphtag="h1">
						<children>
							<text fixtext="Deployment Log"/>
						</children>
					</paragraph>
					<template>
						<match match="Configuration"/>
						<children>
							<table dynamic="1" topdown="0">
								<properties border="0"/>
								<children>
									<tablebody>
										<children>
											<tablerow>
												<children>
													<tablecol>
														<children>
															<text fixtext="Source:">
																<styles font-weight="bold"/>
															</text>
														</children>
													</tablecol>
													<tablecol dynamic="1">
														<children>
															<template>
																<match match="ImagePath"/>
																<children>
																	<xpath allchildren="1"/>
																</children>
															</template>
														</children>
													</tablecol>
												</children>
											</tablerow>
											<tablerow>
												<children>
													<tablecol>
														<children>
															<text fixtext="Date:">
																<styles font-weight="bold"/>
															</text>
														</children>
													</tablecol>
													<tablecol dynamic="1">
														<children>
															<template>
																<match match="TimeStamp"/>
																<children>
																	<xpath allchildren="1"/>
																</children>
															</template>
														</children>
													</tablecol>
												</children>
											</tablerow>
											<tablerow>
												<children>
													<tablecol>
														<children>
															<text fixtext="Target:">
																<styles font-weight="bold"/>
															</text>
														</children>
													</tablecol>
													<tablecol dynamic="1">
														<children>
															<template>
																<match match="Target"/>
																<children>
																	<xpath allchildren="1"/>
																</children>
															</template>
														</children>
													</tablecol>
												</children>
											</tablerow>
										</children>
									</tablebody>
								</children>
							</table>
							<newline/>
							<paragraph paragraphtag="h2">
								<children>
									<text fixtext="Pre-Strip Image Statistics"/>
								</children>
							</paragraph>
							<template>
								<match match="ImageStatistics"/>
								<children>
									<table dynamic="1" topdown="0">
										<properties border="1"/>
										<children>
											<tablebody>
												<children>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<text fixtext="Objects:"/>
																</children>
															</tablecol>
															<tablecol dynamic="1">
																<children>
																	<template>
																		<match match="ObjectCount"/>
																		<children>
																			<xpath allchildren="1"/>
																		</children>
																	</template>
																</children>
															</tablecol>
														</children>
													</tablerow>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<text fixtext="Classes:"/>
																</children>
															</tablecol>
															<tablecol dynamic="1">
																<children>
																	<template>
																		<match match="ClassCount"/>
																		<children>
																			<xpath allchildren="1"/>
																		</children>
																	</template>
																</children>
															</tablecol>
														</children>
													</tablerow>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<text fixtext="Methods:"/>
																</children>
															</tablecol>
															<tablecol dynamic="1">
																<children>
																	<template>
																		<match match="MethodCount"/>
																		<children>
																			<xpath allchildren="1"/>
																		</children>
																	</template>
																</children>
															</tablecol>
														</children>
													</tablerow>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<text fixtext="Symbols"/>
																</children>
															</tablecol>
															<tablecol dynamic="1">
																<children>
																	<template>
																		<match match="SymbolCount"/>
																		<children>
																			<xpath allchildren="1"/>
																		</children>
																	</template>
																</children>
															</tablecol>
														</children>
													</tablerow>
												</children>
											</tablebody>
										</children>
									</table>
								</children>
							</template>
							<newline/>
							<newline/>
							<template>
								<match match="DevelopmentMethodCategories"/>
								<children>
									<table dynamic="1">
										<properties border="1"/>
										<children>
											<tableheader>
												<children>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<text fixtext="MethodCategory"/>
																</children>
															</tablecol>
														</children>
													</tablerow>
												</children>
											</tableheader>
											<tablebody>
												<children>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<template>
																		<match match="MethodCategory"/>
																		<children>
																			<xpath allchildren="1"/>
																		</children>
																	</template>
																</children>
															</tablecol>
														</children>
													</tablerow>
												</children>
											</tablebody>
										</children>
									</table>
								</children>
							</template>
							<newline/>
							<newline/>
							<template>
								<match match="RequiredMethodCategories"/>
								<children>
									<table dynamic="1">
										<properties border="1"/>
										<children>
											<tableheader>
												<children>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<text fixtext="MethodCategory"/>
																</children>
															</tablecol>
														</children>
													</tablerow>
												</children>
											</tableheader>
											<tablebody>
												<children>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<template>
																		<match match="MethodCategory"/>
																		<children>
																			<xpath allchildren="1"/>
																		</children>
																	</template>
																</children>
															</tablecol>
														</children>
													</tablerow>
												</children>
											</tablebody>
										</children>
									</table>
								</children>
							</template>
							<newline/>
							<newline/>
							<template>
								<match match="PreservedMessages"/>
								<children>
									<table dynamic="1">
										<properties border="1"/>
										<children>
											<tableheader>
												<children>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<text fixtext="Selector"/>
																</children>
															</tablecol>
														</children>
													</tablerow>
												</children>
											</tableheader>
											<tablebody>
												<children>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<template>
																		<match match="Selector"/>
																		<children>
																			<xpath allchildren="1"/>
																		</children>
																	</template>
																</children>
															</tablecol>
														</children>
													</tablerow>
												</children>
											</tablebody>
										</children>
									</table>
								</children>
							</template>
							<newline/>
						</children>
					</template>
					<newline/>
					<newline/>
					<newline/>
					<newline/>
					<newline/>
					<template>
						<match match="Manifest"/>
						<children>
							<newline/>
							<table dynamic="1" topdown="0">
								<properties border="1"/>
								<children>
									<tablebody>
										<children>
											<tablerow>
												<children>
													<tablecol>
														<children>
															<text fixtext="Total Instances"/>
														</children>
													</tablecol>
													<tablecol dynamic="1">
														<children>
															<template>
																<match match="TotalInstances"/>
																<children>
																	<xpath allchildren="1"/>
																</children>
															</template>
														</children>
													</tablecol>
												</children>
											</tablerow>
											<tablerow>
												<children>
													<tablecol>
														<children>
															<text fixtext="Total Methods"/>
														</children>
													</tablecol>
													<tablecol dynamic="1">
														<children>
															<template>
																<match match="TotalMethods"/>
																<children>
																	<xpath allchildren="1"/>
																</children>
															</template>
														</children>
													</tablecol>
												</children>
											</tablerow>
											<tablerow>
												<children>
													<tablecol>
														<children>
															<text fixtext="Total Class Methods"/>
														</children>
													</tablecol>
													<tablecol dynamic="1">
														<children>
															<template>
																<match match="TotalClassMethods"/>
																<children>
																	<xpath allchildren="1"/>
																</children>
															</template>
														</children>
													</tablecol>
												</children>
											</tablerow>
										</children>
									</tablebody>
								</children>
							</table>
							<template>
								<match match="Classes"/>
								<children>
									<table dynamic="1">
										<properties border="1"/>
										<children>
											<tableheader>
												<children>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<text fixtext="Class"/>
																</children>
															</tablecol>
														</children>
													</tablerow>
												</children>
											</tableheader>
											<tablebody>
												<children>
													<tablerow>
														<children>
															<tablecol>
																<children>
																	<template>
																		<match match="Class"/>
																		<children>
																			<table dynamic="1">
																				<properties border="1"/>
																				<children>
																					<tableheader>
																						<children>
																							<tablerow>
																								<children>
																									<tablecol>
																										<children>
																											<text fixtext="count"/>
																										</children>
																									</tablecol>
																									<tablecol>
																										<children>
																											<text fixtext="unbound"/>
																										</children>
																									</tablecol>
																									<tablecol>
																										<children>
																											<text fixtext="Name"/>
																										</children>
																									</tablecol>
																									<tablecol>
																										<children>
																											<text fixtext="Methods"/>
																										</children>
																									</tablecol>
																									<tablecol>
																										<children>
																											<text fixtext="ClassMethods"/>
																										</children>
																									</tablecol>
																								</children>
																							</tablerow>
																						</children>
																					</tableheader>
																					<tablebody>
																						<children>
																							<tablerow>
																								<children>
																									<tablecol>
																										<children>
																											<template>
																												<match match="@count"/>
																												<children>
																													<xpath allchildren="1"/>
																												</children>
																											</template>
																										</children>
																									</tablecol>
																									<tablecol>
																										<children>
																											<template>
																												<match match="@unbound"/>
																												<children>
																													<xpath allchildren="1"/>
																												</children>
																											</template>
																										</children>
																									</tablecol>
																									<tablecol>
																										<children>
																											<template>
																												<match match="Name"/>
																												<children>
																													<xpath allchildren="1"/>
																												</children>
																											</template>
																										</children>
																									</tablecol>
																									<tablecol>
																										<children>
																											<template>
																												<match match="Methods"/>
																												<children>
																													<table dynamic="1">
																														<properties border="1"/>
																														<children>
																															<tablebody>
																																<children>
																																	<tablerow>
																																		<children>
																																			<tablecol>
																																				<children>
																																					<template>
																																						<match match="Method"/>
																																						<children>
																																							<xpath allchildren="1"/>
																																						</children>
																																					</template>
																																				</children>
																																			</tablecol>
																																		</children>
																																	</tablerow>
																																</children>
																															</tablebody>
																														</children>
																													</table>
																												</children>
																											</template>
																										</children>
																									</tablecol>
																									<tablecol>
																										<children>
																											<template>
																												<match match="ClassMethods"/>
																												<children>
																													<table dynamic="1">
																														<properties border="1"/>
																														<children>
																															<tablebody>
																																<children>
																																	<tablerow>
																																		<children>
																																			<tablecol>
																																				<children>
																																					<template>
																																						<match match="Method"/>
																																						<children>
																																							<xpath allchildren="1"/>
																																						</children>
																																					</template>
																																				</children>
																																			</tablecol>
																																		</children>
																																	</tablerow>
																																</children>
																															</tablebody>
																														</children>
																													</table>
																												</children>
																											</template>
																										</children>
																									</tablecol>
																								</children>
																							</tablerow>
																						</children>
																					</tablebody>
																				</children>
																			</table>
																		</children>
																	</template>
																</children>
															</tablecol>
														</children>
													</tablerow>
												</children>
											</tablebody>
										</children>
									</table>
								</children>
							</template>
						</children>
					</template>
					<newline/>
				</children>
			</template>
		</children>
	</template>
	<template>
		<match match="Class"/>
		<children>
			<xpath allchildren="1"/>
		</children>
	</template>
	<template>
		<match match="ClassCount"/>
		<children>
			<xpath allchildren="1"/>
		</children>
	</template>
	<template>
		<match match="ClassMethods"/>
		<children>
			<xpath allchildren="1"/>
		</children>
	</template>
	<template>
		<match match="Classes"/>
		<children>
			<xpath allchildren="1"/>
		</children>
	</template>
	<template>
		<match match="Configuration"/>
		<children>
			<xpath allchildren="1"/>
		</children>
	</template>
	<template>
		<match match="DetailMessage"/>
		<children>
			<xpath allchildren="1"/>
		</children>
	</template>
	<template>
		<match match="DevelopmentMethodCategories"/>
		<children>
			<xpath allchildren="1"/>
		</children>
	</template>
	<template>
		<match match="GUID"/>
		<children>
			<xpath allchildren="1"/>
		</children>
	</template>
	<template>
		<match match="ImagePath"/>
		<children>
			<xpath allchildren="1"/>
		</children>
	</template>
</structure>
